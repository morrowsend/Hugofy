#!/bin/bash

while getopts r:m:d: OPT
do
  case $OPT in
    "r" ) FLG_G=1 ; REPOSITORY="$OPTARG" ;;
    "m" ) FLG_M=1 ; COMMIT_MESSAGE="$OPTARG" ;;
    "d" ) FLG_D=1 ; DIRECTORY="$OPTARG" ;;
  esac
done

cd $DIRECTORY

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ "$FLG_M" ] && [ -n "$COMMIT_MESSAGE" ]
  then msg=$COMMIT_MESSAGE
fi
git commit -m "$msg"
# Push source and build repos.
remote_repository="origin"
if [ "$FLG_G" ]
  then remote_repository=$REPOSITORY
fi
git push $remote_repository master
git subtree push --prefix=public $remote_repository gh-pages
