#!/usr/bin/env bash

set -euo pipefail

############################################
# Validate input
############################################

if [[ $# -ne 1 ]]; then
    echo "Usage:"
    echo "  ./get-github-action-sha.sh <github-action>"
    echo
    echo "Example:"
    echo "  ./get-github-action-sha.sh actions/checkout"
    echo "  ./get-github-action-sha.sh github/codeql-action/upload-sarif"
    exit 1
fi

############################################
# Normalize input
############################################

INPUT="$1"

# Extract owner/repo only
REPO="$(cut -d'/' -f1-2 <<< "$INPUT")"

REPO_URL="https://github.com/${REPO}.git"

############################################
# Validate repository exists
############################################

if ! git ls-remote "$REPO_URL" &>/dev/null; then
    echo "ERROR: Repository not found:"
    echo "  $REPO_URL"
    exit 1
fi

############################################
# Fetch latest 5 version tags
############################################

TAGS=$(
    git ls-remote --tags --sort='version:refname' "$REPO_URL" \
    | awk '!/\^\{\}$/ { print $2 }' \
    | sed 's|refs/tags/||' \
    | tail -5 \
    | tac
)

############################################
# Output
############################################

echo
echo "Recent 5 release versions"
echo "--------------------------------------------------------------"

while read -r TAG; do

    [[ -z "$TAG" ]] && continue

    SHA=$(
        git ls-remote --tags "$REPO_URL" "${TAG}*" \
        | tail -1 \
        | cut -f1
    )

    echo "${INPUT}@${SHA} # ${TAG}"

done <<< "$TAGS"
