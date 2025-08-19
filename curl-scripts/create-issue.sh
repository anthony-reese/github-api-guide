#!/bin/bash
# Create an issue in a repo

REPO=securitypro-docs
OWNER=ar

curl -s -X POST https://api.github.com/repos/$OWNER/$REPO/issues \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Bug from CLI","body":"Issue created using curl"}' | jq
