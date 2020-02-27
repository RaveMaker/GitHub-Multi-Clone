#!/bin/bash

# Clone all User or Organization repositories from GitHub
#
# by RaveMaker - http://ravemaker.net
#
# GitHub Limitations:
# For unauthenticated requests, the rate limit allows you to make up to 60 requests per hour.

# Load settings
if [ -f settings.cfg ]; then
  echo "Loading settings..."
  . settings.cfg
  echo "Cloning Git: $GIT_NAME"
else
  echo "ERROR: Create settings.cfg (from settings.cfg.example)"
  exit
fi

# CONSTS
REPOS_LIST="repos-list.txt"
GIT_URL_USER="https://api.github.com/users"
GIT_URL_ORG="https://api.github.com/orgs"
# GitHub limit of repos in one call 100
REPO_NUM=100

# Vars
GITHUB_PAGE=1
LAST_PAGE="false"

# User mode or Org Mode
if [ "$USER_ORG" == "1" ]; then
  GIT_TO_CLONE="$GIT_URL_USER/$GIT_NAME"
elif [ "$USER_ORG" == "2" ]; then
  GIT_TO_CLONE="$GIT_URL_ORG/$GIT_NAME"
else
  echo "Please select User/Organization mode"
  exit
fi

function get-repos-list() {
  # Get repos url list from GitHub
  echo "Downloading Repo list page $GITHUB_PAGE"
  if [ "$GIT_HTTPS" == "1" ]; then
    #get git repos url list
    curl -s "$GIT_TO_CLONE/repos?per_page=$REPO_NUM&page=$GITHUB_PAGE" | grep -o 'git@[^"]*' >$REPOS_LIST
  elif [ "$GIT_HTTPS" == "2" ]; then
    #get https repos url list
    curl -s "$GIT_TO_CLONE/repos?per_page=$REPO_NUM&page=$GITHUB_PAGE" | grep -w clone_url | grep -o '[^"]\+://.\+.git'>$REPOS_LIST
  else
    echo "Please select GIT/HTTPS mode"
    exit
  fi
}

# Clone GitHub repositories from URLs list file
function clone-repos() {
  while read -r REPO; do
    echo "Cloning repo: $REPO"
    if [ "$DEBUG_MODE" == "false" ]; then
      git clone "$REPO"
    fi
  done<"$REPOS_LIST"
  REPO_COUNT=$(wc -l <"$REPOS_LIST")
  if ((REPO_COUNT<REPO_NUM)); then
    LAST_PAGE="true"
    TOTAL_REPOS=$((REPO_NUM*GITHUB_PAGE+REPO_COUNT-REPO_NUM))
    echo "Cloned $TOTAL_REPOS"
  fi
  ((GITHUB_PAGE+=1))
}

# Create destination folder if not exist
cd "$DEST_FOLDER" 2> /dev/null || { echo "Destination folder doesn't exist" ; exit; }
echo -n "Selected destination: "
pwd

# Clone repos
while [ "$LAST_PAGE" == "false" ]; do
  get-repos-list
  clone-repos
done

# Remove repos list
rm -f "$REPOS_LIST"
