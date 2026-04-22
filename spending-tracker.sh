#!/bin/bash
# ~/.claude/hooks/spending-tracker.sh
#
# Tracks cumulative Claude Code spending and alerts on every $10 increment.
# Runs on the Stop hook (after each Claude response).
#
# Pricing is for claude-sonnet-4-6. Adjust the PRICE_* variables below if you
# switch models. Rates are in USD per 1,000,000 tokens.
#
# Data is persisted in: ~/.claude/spending_tracker.json

set -euo pipefail

# ── Configuration ──────────────────────────────────────────────────────────────
TRACKER_FILE="$HOME/.claude/spending_tracker.json"
ALERT_INTERVAL=10        # Alert every $N of cumulative spend

# claude-sonnet-4-6 pricing (USD per 1M tokens)
PRICE_INPUT=3.00
PRICE_OUTPUT=15.00
PRICE_CACHE_WRITE=3.75
PRICE_CACHE_READ=0.30
# ───────────────────────────────────────────────────────────────────────────────

# Read hook input
INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || true)
SESSION_ID=$(echo "$INPUT"      | jq -r '.session_id // empty'      2>/dev/null || true)

# Bail early if missing required info
[[ -z "$SESSION_ID" || -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]] && exit 0

# Require jq
if ! command -v jq &>/dev/null; then
    jq -n '{"systemMessage": "spending-tracker: jq not found – install it to enable spend tracking"}'
    exit 0
fi

# Initialise tracker file
if [[ ! -f "$TRACKER_FILE" ]]; then
    printf '{"total_spent":0,"last_alert_at":0,"sessions":{}}\n' > "$TRACKER_FILE"
fi

# ── Calculate this session's total cost from transcript ────────────────────────
SESSION_COST=$(jq -rcs \
    --argjson ip  "$PRICE_INPUT"       \
    --argjson op  "$PRICE_OUTPUT"      \
    --argjson cwp "$PRICE_CACHE_WRITE" \
    --argjson crp "$PRICE_CACHE_READ"  \
    '
    map(select(.type == "assistant" and (.message.usage != null))) |
    reduce .[] as $m (
        {input:0, output:0, cw:0, cr:0};
        .input  += ($m.message.usage.input_tokens                    // 0) |
        .output += ($m.message.usage.output_tokens                   // 0) |
        .cw     += ($m.message.usage.cache_creation_input_tokens     // 0) |
        .cr     += ($m.message.usage.cache_read_input_tokens         // 0)
    ) |
    (.input * $ip + .output * $op + .cw * $cwp + .cr * $crp) / 1000000
    ' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")

# Sanitise – fall back to 0 if non-numeric
[[ "$SESSION_COST" =~ ^[0-9]+(\.[0-9]+)?$ ]] || SESSION_COST=0

# ── Read current tracker state ─────────────────────────────────────────────────
TRACKER=$(cat "$TRACKER_FILE")
PREV_SESSION_COST=$(echo "$TRACKER" | jq -r --arg s "$SESSION_ID" '.sessions[$s] // 0')
TOTAL_SPENT=$(echo "$TRACKER"       | jq -r '.total_spent    // 0')
LAST_ALERT=$(echo "$TRACKER"        | jq -r '.last_alert_at  // 0')

# new total = old total + (session cost now − session cost last recorded)
NEW_TOTAL=$(awk "BEGIN { v = $TOTAL_SPENT + ($SESSION_COST - $PREV_SESSION_COST); printf \"%.8f\", (v < 0 ? 0 : v) }")

# ── Persist updated session cost and total ─────────────────────────────────────
jq \
    --arg  sid "$SESSION_ID"   \
    --argjson sc  "$SESSION_COST" \
    --argjson nt  "$NEW_TOTAL"    \
    '.sessions[$sid] = $sc | .total_spent = $nt' \
    "$TRACKER_FILE" > "${TRACKER_FILE}.tmp" && mv "${TRACKER_FILE}.tmp" "$TRACKER_FILE"

# ── Alert check ────────────────────────────────────────────────────────────────
NEXT_THRESHOLD=$(awk "BEGIN { printf \"%d\", int($LAST_ALERT) + $ALERT_INTERVAL }")
CROSSED=$(awk "BEGIN { print ($NEW_TOTAL >= $NEXT_THRESHOLD) ? 1 : 0 }")

if [[ "$CROSSED" == "1" ]]; then
    # Advance last_alert_at to the highest $ALERT_INTERVAL multiple we've crossed
    NEW_ALERT_AT=$(awk "BEGIN { printf \"%d\", int($NEW_TOTAL / $ALERT_INTERVAL) * $ALERT_INTERVAL }")

    jq --argjson na "$NEW_ALERT_AT" '.last_alert_at = $na' \
        "$TRACKER_FILE" > "${TRACKER_FILE}.tmp" && mv "${TRACKER_FILE}.tmp" "$TRACKER_FILE"

    FORMATTED_TOTAL=$(printf "%.4f" "$NEW_TOTAL")
    MSG="Total Claude Code spending: \$$FORMATTED_TOTAL  (crossed \$$NEXT_THRESHOLD threshold)"

    # macOS native notification (silent failure on non-macOS or if perms unavailable)
    osascript -e "display notification \"$MSG\" with title \"Claude Code Spending Alert\"" 2>/dev/null || true

    # Surfaced in the Claude Code UI as a warning banner
    jq -n --arg m "$MSG" '{"systemMessage": $m}'
fi

exit 0
