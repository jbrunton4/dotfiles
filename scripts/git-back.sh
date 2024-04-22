#!/bin/bash

if [[ "$1" == "drop" ]]; then 
    git branch --list 'backup/*' | xargs git branch -D
    exit 0
fi

git stash -u -m "Backup at $(date): $(git diff --start | awk 'END{print}')" && git branch "backup/$(git rev-parse --abbrev-ref HEAD)/$(date +%s)" stash@{0} && git stash pop
