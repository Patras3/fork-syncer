#!/bin/bash

set -e

check_command() {
  if ! [ -x "$(command -v "$1")" ]; then
    echo "Error: '$1' tool required - $2"
    exit 2
  fi
}

check_command "gh" "https://cli.github.com/"
check_command "jq" "https://jqlang.github.io/jq/download/"

# https://github.com/mislav/hub/issues/2923#issuecomment-1062045270
github_username=$(gh api user | jq -r '.login')

# List and iterate through the forked repositories to synchronize
gh repo list --fork --json name "$github_username" | jq -c '.[]' | while read -r repo_data; do
  repo_name=$(echo "$repo_data" | jq -r '.name')
  gh repo sync "$github_username/$repo_name"
done