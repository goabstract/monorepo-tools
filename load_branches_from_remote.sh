#!/usr/bin/env bash

# Delete all local branches and create all non-remote-tracking branches of a specified remote
#
# Usage: load_branches_from_remote.sh <remote-name> <branch-prefix> [--master]
#
# Example: load_branches_from_remote.sh origin packages/package-a --master

REMOTE=$1
PREFIX=$2
INCLUDE_MASTER=${@:3}

echo "Loading all branches from the remote '$REMOTE' (all local branches are deleted)"
# Create non-remote-tracking branches from selected remote
for REMOTE_BRANCH in $(git branch -r|grep $REMOTE/); do
    BRANCH=${REMOTE_BRANCH/$REMOTE\//}

    if [ "$BRANCH" == "master" ] && [ "$INCLUDE_MASTER" == "--master" ]; then
        git branch -q $BRANCH $REMOTE_BRANCH
        git branch --unset-upstream $BRANCH
    elif [ "$BRANCH" != "master" ]; then
        git branch -q $PREFIX--$BRANCH $REMOTE_BRANCH
        git branch --unset-upstream $PREFIX--$BRANCH
    fi
done
git checkout -f master

