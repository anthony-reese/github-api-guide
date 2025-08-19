#!/bin/bash
# Star a repo

REPO=securitypro-docs
OWNER=ar

curl -s -X PUT -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Length: 0" \
  https://api.github.com/user/starred/$OWNER/$REPO -w "\nStatus: %{http_code}\n"
