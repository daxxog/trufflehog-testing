#!/bin/bash
set -x

# Check if REPO_NAME is set
if [ -z "$REPO_NAME" ]; then
    echo "The REPO_NAME environment variable is not set. Please set it and rerun the script."
    exit 1
fi

# The bare repository location
BARE_REPO="/mnt/git"

# Temporary directory for non-bare repository
TEMP_REPO="/tmp/temp_repo"

# Output file
OUTPUT_FILE="/mnt/output/trufflehog..__..${REPO_NAME}..__..$(date +%F)_$(date +%T | tr : -).yaml"

# Create an empty git repository
mkdir "$TEMP_REPO"
cd "$TEMP_REPO"
git init

# Fetch all objects from the bare repository
git remote add origin "$BARE_REPO"
git fetch origin

# Get the truffleHog version
TRUFFLEHOG_VERSION=$(trufflehog --version 2>&1)

# Print the scanner_version, scanner_origin, trufflehog_version, and repo_name
echo "---" > "$OUTPUT_FILE"
echo "scanner_version: '${SCANNER_VERSION}'" >> "$OUTPUT_FILE"
echo "scanner_origin: '${SCANNER_ORIGIN}'" >> "$OUTPUT_FILE"
echo "trufflehog_version: '${TRUFFLEHOG_VERSION}'" >> "$OUTPUT_FILE"
echo "repo_name: '${REPO_NAME}'" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"

# Run trufflehog on the entire repository, output to JSON, then append to YAML
trufflehog --json git file://$(pwd) | awk 'BEGIN{ORS=""}{if(NR>1){print "\n---\n" $0}else{print $0}}' >> "$OUTPUT_FILE"
