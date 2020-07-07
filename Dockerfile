FROM ubuntu:18.04

# Make sure that apt-get doesn't prompt
# See https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package

ENV DEBIAN_FRONTEND=noninteractive

# Install gnina build dependencies
# See https://github.com/gnina/gnina

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install \
    apt-transport-https \
    build-essential \
    ca-certificates \
    git \
    gnupg \
    libatlas-base-dev \
    libboost-all-dev \
    libeigen3-dev \
    libgoogle-glog-dev \
    libhdf5-serial-dev \
    libprotobuf-dev \
    librdkit-dev \
    linux-headers-generic \
    protobuf-compiler \
    python3-dev \
    python3-numpy \
    python3-pip \
    software-properties-common \
    swig \
    wget

# We need a more recent version of cmake than 18.04 has by default
# See https://apt.kitware.com

RUN wget https://apt.kitware.com/keys/kitware-archive-latest.asc
RUN gpg --dearmor - < kitware-archive-latest.asc > /etc/apt/trusted.gpg.d/kitware.gpg
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt-get update
RUN apt-get -y install cmake

# Install CUDA
# See https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
RUN mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
RUN apt-get update
RUN apt-get -y install cuda

ENV PATH=/usr/local/cuda-11.0/bin:$PATH
RUN ls /usr/local/cuda-11.0/
ENV CUDACXX=nvcc

# Install maeparser
# See https://github.com/schrodinger/maeparser
RUN mkdir /maeparser
WORKDIR /maeparser
RUN git clone https://github.com/schrodinger/maeparser.git
WORKDIR maeparser
#RUN git checkout v1.2.3
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make -j install

# Install coordgen
# See https://github.com/schrodinger/coordgenlibs
RUN mkdir /coordgen
WORKDIR /coordgen
RUN git clone https://github.com/schrodinger/coordgenlibs.git
WORKDIR coordgenlibs
#RUN git checkout v1.4.1
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make -j install

# Install OpenBabel
# See https://open-babel.readthedocs.io/en/latest/Installation/install.html

RUN mkdir /openbabel
WORKDIR /openbabel
RUN wget https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2
RUN tar xf openbabel-3.1.1-source.tar.bz2
RUN mkdir build
WORKDIR build
RUN cmake ../openbabel-3.1.1 -DPYTHON_BINDINGS=ON -DBUILD_GUI=OFF
RUN make -j4
RUN make install
RUN obabel --help

# Install libmolgrid
# See https://github.com/gnina/libmolgrid

RUN mkdir /libmolgrid
WORKDIR /libmolgrid
RUN pip3 install numpy pytest pyquaternion
RUN git clone https://github.com/gnina/libmolgrid.git
RUN mkdir -p libmolgrid/build
WORKDIR libmolgrid/build
RUN cmake .. #-DOPENBABEL3_INCLUDE_DIR=/usr/local/include/openbabel3
RUN make -j4
RUN make install

# Build gnina
# See https://github.com/gnina/gnina

RUN mkdir /gnina
WORKDIR /gnina
RUN git clone https://github.com/glesica/gnina.git
WORKDIR gnina
RUN git checkout build-for-docker
RUN mkdir build
WORKDIR build
RUN cmake .. #-DOPENBABEL3_INCLUDE_DIR=/usr/local/include/openbabel3
RUN make -j4
RUN make install

# Create a volume that we can mount externally for code and such
#VOLUME /code

# Run a shell by default for interactive testing

#WORKDIR /code
ENTRYPOINT /bin/bash

