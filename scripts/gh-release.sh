#!/usr/bin/env bash

    NAME="$TAG"
    BODY="release $TAG"
    REPO="form3tech/docker-terraform-bundle"
    FILE="$(git rev-parse --show-toplevel)/output/$1"

    payload=$(
      jq --null-input \
         --arg tag "$TAG" \
         --arg name "$NAME" \
         --arg body "$BODY" \
         '{ tag_name: $tag, name: $name, body: $body, draft: false }'
    )

    response=$(
      curl -d "$payload" \
           "https://api.github.com/repos/$REPO/releases?access_token=$GITHUB_TOKEN"
    )

    upload_url="$(echo "$response" | jq -r .upload_url | sed -e "s/{?name,label}//")"

    curl -H "Content-Type:application/octet-stream" \
         --data-binary "@$FILE" \
           "$upload_url?name=$(basename "$FILE")&access_token=$GITHUB_TOKEN"
