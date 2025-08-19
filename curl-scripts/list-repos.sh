#!/bin/bash
# List repositories for authenticated user

curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos | jq
