![Docker Image CI](https://github.com/TravisWheelerLab/gnina-image/workflows/Docker%20Image%20CI/badge.svg)

**Note: This project is unmaintained**

The gnina project now offers its own Docker images, so users who want to run
gnina in a container should use those instead. See:
<https://hub.docker.com/u/gnina>.

# gnina Docker Image

A Docker image that can be used to run [gnina](https://github.com/gnina/gnina).
The image can be found on
[Docker Hub](https://hub.docker.com/repository/docker/traviswheelerlab/gnina).
It can be run interactively with the following:

```
$ docker run \
    -it --volume "$PWD":/code:rw \
    traviswheelerlab/gnina:latest
```


or noninteractively with the following:

```
$ docker run \
    --volume "$PWD":/code:rw \
    traviswheelerlab/gnina:latest ./my_gnina_app
```

Both of these commands will mount the current working directory within the
container at `/code`. This directory will also start out as the current working
directory within the running container.

## Description

This image attempts to make gnina a little easier to use, given that it has
quite a few dependencies and isn't the easiest thing in the world to build.

## Tooling

We use a GitHub Action to publish tagged versions of the container to Docker
Hub: <https://github.com/marketplace/actions/build-and-push-docker-images>.

## Authors

  * George Lesica <george.lesica@umontana.edu>
  * Travis Wheeler <travis.wheeler@umontana.edu>

