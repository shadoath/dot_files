#!/usr/bin/env ruby
# Dependencies: brew install pngpaste imagemagick
# Captures clipboard image, saves to /tmp, and resizes for AI reading

require 'tempfile'
require 'time'

# Generate filename with timestamp
filename = ARGV[0] || "clipboard_#{Time.now.strftime('%Y%m%d_%H%M%S')}.png"
output_path = "/tmp/#{filename}"

# Create temp file for initial clipboard capture
temp_file = Tempfile.new(['clipboard', '.png'])
temp_path = temp_file.path
temp_file.close

# Capture clipboard image
unless system("pngpaste #{temp_path} 2>/dev/null")
  STDERR.puts "Error: No image found in clipboard"
  exit 1
end

# Resize image to max 2048px on longest side while maintaining aspect ratio
system("magick #{temp_path} -resize '2048x2048>' #{output_path}")

# Clean up temp file
temp_file.unlink

# Output only the filename
puts output_path
