#!/bin/sh

# Rebuild the Docker image from the current Dockerfile and push it to the Hub.
# This requires being logged into Docker Hub with sufficient permissions within
# the organization.

docker build -t traviswheelerlab/gnina:builderror .

