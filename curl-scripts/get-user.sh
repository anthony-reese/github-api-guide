#!/bin/bash
# Get authenticated user info

curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | jq
