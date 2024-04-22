#!/bin/bash

git stash -u -m "Backup at $(date): $(git diff --start | awk 'END{print}')" && git branch "backup/$(git rev-parse --abbrev-ref HEAD)/$(date +%s)" stash@{0} && git stash pop
