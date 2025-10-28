#!/bin/bash
###
# Setup script for the development container
###
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

# TODO: setup more git config based on https://github.com/kayhadrin/git-utils

CLI_HELPERS_DIR="$SCRIPT_DIR"
touch "$CLI_HELPERS_DIR/.bash_history.local"

# # Copy these files to the repo level to make it easier to access them even after
# # switching to an old git branch that didn't have this setup
# if [ -f ./.bash_aliases.local ]; then
#   cp "$SCRIPT_DIR/.bash_aliases.local" "$REPO_DIR"
# fi
# cp "$SCRIPT_DIR/git_prompt.sh" "$REPO_DIR"

# Append to .bashrc
cat << EOM >> ~/.bashrc

# Enable bash command history
export PROMPT_COMMAND='history -a'
export HISTFILE="$CLI_HELPERS_DIR/.bash_history.local"

if [ -f "$CLI_HELPERS_DIR/.bash_aliases.local" ]; then
    . "$CLI_HELPERS_DIR/.bash_aliases.local"
fi

# Import git prompt
. "$CLI_HELPERS_DIR/git_prompt.sh"

EOM
