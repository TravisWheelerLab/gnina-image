#!/bin/sh

set -e

# Rebuild the Docker image from the current Dockerfile and push it to the Hub.
# This requires being logged into Docker Hub with sufficient permissions within
# the organization.

TAG_VERSION=${TAG_VERSION:-"local"}

docker build \
    -t "traviswheelerlab/gnina:latest" \
    -t "traviswheelerlab/gnina:$TAG_VERSION" \
    .

if [ "$TAG_VERSION" == "local" ]; then
    echo "Skipping push for local build"
    exit 0
fi

docker push "traviswheelerlab/gnina:$TAG_VERSION"

