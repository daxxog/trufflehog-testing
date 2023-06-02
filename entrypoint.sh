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

# Run trufflehog on the entire repository, output to JSON, then transform to YAML
trufflehog --json git file://$(pwd) | awk 'BEGIN{ORS=""}{print "---\n" $0 "\n"}' > "$OUTPUT_FILE"
