#!/bin/bash
##############################
# OPTIONAL!
# The VS Code Dev Container extension should automatically copy your global git config to the container.
# @see https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials
#
# Git configuration script to achieve about the same config as .gitconfig
# Inspired by https://github.com/kayhadrin/git-utils/blob/master/git-config.sh
##############################

set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CLI_HELPERS_DIR="$SCRIPT_DIR"

cd "$SCRIPT_DIR"

# always push only the current branch
git config --global push.default current
 
# always do non-fast forward merges
# it gives more clarity to commit graphs after each merge
git config --global merge.ff false
 
# save all text files with LF (instead of letting git make guesses like CRLF, LF per OS type)
# helps us reduce minor file diff mismatches
git config --global core.autocrlf input
 
git config --global color.ui auto
 
# Remember your git credentials when authenticating in command-line
# For VS Code
# It should be handled by the IDE.
#
# For Windows, see: scoop/apps/git/2.50.0/mingw64/bin/git-credential-manager.exe
# git config --global credential.helper ...TBD...
#
# For Linunx, TBD
# git config --global credential.helper ...TBD...
 
# Enable git client to store and checkout repositories that contain long file paths (>256) on Windows
# Requires git v1.9.4+
git config --global core.longpaths true
 
# Aliases
# nice git log views
git config --global alias.gl "log --graph --decorate --oneline"
git config --global alias.lg1 "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold magenta)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
git config --global alias.lg2 "log --graph --abbrev-commit --decorate --format=format:'%C(bold magenta)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
git config --global alias.lg '!'"git lg2"
# an alias to get the git repo root folder
git config --global alias.show-root-folder "rev-parse --show-toplevel"
# show git logs in one vertical view (no graph)
git config --global alias.one "log --pretty=oneline --abbrev-commit"
# Show git commit graph with gitk
# Very useful to find the change history of a single file
# because it keeps merge commits that impacted a given file path.
# @note $GIT_PREFIX is needed to go to the current directory of the script caller
git config --global alias.history '!''cd "$GIT_PREFIX" && gitk --simplify-merges'
 
# shortcuts for common git commands
git config --global alias.a "add"
git config --global alias.br "brecent"
# Inspired from: https://stackoverflow.com/a/5188364/104598
git config --global alias.brecent "branch --sort=-committerdate --format='%(HEAD) %(align:40)%(color:yellow)%(refname:short)%(color:reset)%(end) (%(color:green)%(committerdate:relative)%(color:reset)) %(color:magenta)%(objectname:short)%(color:reset): %(contents:subject) %(color:dim white)- %(authorname)%(color:reset)'"
git config --global alias.c "commit"
git config --global alias.ca "commit --amend"
git config --global alias.ci "commit -a"
git config --global alias.co "checkout"
git config --global alias.d "diff"
git config --global alias.dc "diff --changed"
git config --global alias.ds "diff --staged"
git config --global alias.f "fetch"
git config --global alias.s "status"
# fetch and prune
git config --global alias.fp "fetch -p"
git config --global alias.pf "pull --ff"
git config --global alias.m "merge"

git config --global alias.children-of '!f() { root=$(git rev-parse "$1"); git log --format="%H %P" --all "$root" | grep -F " "$root | cut -f1 -d " "; }; f $1'
# Checkout the direct child commit of the current HEAD.
script='! f() { 
  set -e ;
  children="$(git children-of HEAD)"; 
  childrenCount=$( echo "$children" | wc -l ); 
  if [ "$childrenCount" -eq "1" ]; 
  then \
    echo Found one child commit: "$children" 1>&2 \
    && git checkout "$children" ; 
  else echo ERROR: found multiple child commits 1>&2 \
    && echo $children 1>&2 \
    && exit 1 ;
  fi ; 
}; f'
eval "git config --global alias.next $(printf "%q" "$script")"

git config --global alias.parents-of '! f() { git log --pretty=%P -n 1 "${1:-HEAD}" | tr " " "\n" ; }; f'
# Checkout the direct parent commit of the current HEAD.
script='! f() { 
  set -e ;
  parents="$(git parents-of HEAD)"; 
  parentsCount=$( echo "$parents" | wc -l ); 
  if [ "$parentsCount" -eq "1" ]; 
  then \
    echo Found one parent commit: "$parents" 1>&2 \
    && git checkout "$parents" ; 
  else echo ERROR: found multiple parent commits 1>&2 \
    && echo "$parents" 1>&2 \
    && exit 1 ;
  fi ; 
}; f'
eval "git config --global alias.previous $(printf "%q" "$script")"

# Produces the git commit range between the 1st and 2st refs
git config --global alias.range-from-ref '! f() { from=$1; to=$2; echo $( git merge-base --all "$from" "$to")..$to ; }; f $1 ${2:-HEAD}'
# Produces the git commit range between the given branch and the target commit $1 (defaults to HEAD)
# E.g. `git gl $(git range-from-dev-branch)`
git config --global alias.range-from-dev-branch '! git range-from-ref origin/dev $1'
git config --global alias.range-from-test-branch '! git range-from-ref origin/test $1'
git config --global alias.range-from-stage-branch '! git range-from-ref origin/stage $1'

git config --global alias.spr-merge '! git spr check && git spr merge'

# Setup VS Code as the default editor for git commit messages
git config --global core.editor "code --wait"

git config commit.template "$CLI_HELPERS_DIR/git_message_template"
