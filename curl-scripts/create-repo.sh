#!/bin/bash
# Create a new repo named from first argument

REPO_NAME=$1

curl -s -X POST https://api.github.com/user/repos \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO_NAME\",\"private\":false}" | jq
