FROM ubuntu:16.04

MAINTAINER marco@bakera.de

RUN apt-get update &&\
    apt-get install -y git vim  make sudo gcc build-essential wget\
    # libs for Python 3.6
    libssl-dev zlib1g-dev libncurses5-dev\
    libncursesw5-dev libreadline-dev libsqlite3-dev\
    libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev\
    liblzma-dev tk-dev &&\
    apt-get clean

WORKDIR /cscirc
RUN git clone https://github.com/cemc/safeexec.git &&\
    git clone https://github.com/cemc/python3jail.git

WORKDIR /cscirc/safeexec
RUN make

WORKDIR /cscirc/py3
RUN wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz &&\
    tar xf Python-3.6.1.tar.xz
WORKDIR /cscirc/py3/Python-3.6.1
RUN ./configure --prefix=/cscirc/python3jail &&\
    make && make install

WORKDIR /cscirc/python3jail
RUN cp /lib64/* lib64 &&\
    cp -r /lib/* lib
RUN mknod -m 0666 ./dev/null c 1 3 &&\
    mknod -m 0666 ./dev/random c 1 8 &&\
    mknod -m 0444 ./dev/urandom c 1 9

# Testing
# Needs to be run with 'docker run --privileged ...'
WORKDIR /cscirc
#RUN ./safeexec/safeexec --chroot_dir python3jail --env_vars PY --exec_dir / --exec /bin/python3 -u -S -c 'print(1+1)'
