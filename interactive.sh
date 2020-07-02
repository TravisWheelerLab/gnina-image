#!/bin/sh

# Run the image interactively, dropping the user into a shell. If the `CODE_DIR`
# environment variable is set, the path it specifies will be mounted within the
# running container. The directory given will be mounted at `/code`. By default,
# the current working directory will be mounted.

CODE_DIR=${CODE_DIR:-$PWD}

docker run \
    --mount src="${CODE_DIR}",target=/code,type=bind \
    traviswheelerlab/gnina:latest

