#!/usr/bin/env bash
# Delete all runs of workflows that are disabled_manually in a given repo.
# Usage: workflow-remover.sh <org> <repo>
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <org> <repo>" >&2
  exit 1
fi

org=$1
repo=$2

workflow_ids=($(gh api "repos/$org/$repo/actions/workflows" | jq '.workflows[] | select(.["state"] | contains("disabled_manually")) | .id'))

for workflow_id in "${workflow_ids[@]}"; do
  echo "Listing runs for the workflow ID $workflow_id"
  run_ids=($(gh api "repos/$org/$repo/actions/workflows/$workflow_id/runs" --paginate | jq '.workflow_runs[].id'))
  echo "$run_ids"
  for run_id in "${run_ids[@]}"; do
    echo "Deleting Run ID $run_id"
    gh api "repos/$org/$repo/actions/runs/$run_id" -X DELETE >/dev/null
  done
done
