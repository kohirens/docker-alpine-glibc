#!/bin/bash

set -e

# Get a bearer token
export TOKEN=$(curl -L --fail -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d "{\"username\": \"${DH_USER}\", \"password\": \"${DH_API_TOKEN}\"}" \
  "https://hub.docker.com/v2/users/login" \
  | jq -r .token)

# List tags, see: https://docs.docker.com/docker-hub/api/latest/#tag/repositories/paths/~1v2~1namespaces~1%7Bnamespace%7D~1repositories~1%7Brepository%7D~1tags/get
# to lookup official image tags, use "library" as the namespace/organization
# alt public endpoint: "https://hub.docker.com/v2/repositories/library/alpine/tags"
# auth endpoint: "https://hub.docker.com/v2/namespaces/{namespace}/repositories/{repository}/tags"
# Get a single tag:
curl -L --fail -s \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://hub.docker.com/v2/namespaces/library/repositories/alpine/tags?page_size=2&page=1" \
  | jq '.results[1].name' -r \
  > "<< parameters.repo >>-<< parameters.img >>.txt"

# See:
curl -L --fail -s \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://hub.docker.com/v2/namespaces/library/repositories/alpine/tags?page_size=7&page=1" \
  "https://hub.docker.com/v2/repositories/<< parameters.repo >>/<< parameters.img >>/tags/?page_size=7" \
  | jq '.results | .[] | .name' -r \
  | sed 's/latest|edge//' \
  | sort -Vr