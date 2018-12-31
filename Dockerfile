FROM ubuntu:xenial

LABEL authors="akuhak@gmail.com"

ENV PS2DEV /usr/local/ps2dev
ENV PS2SDK $PS2DEV/ps2sdk
ENV PATH   $PATH:$PS2DEV/bin:$PS2DEV/ee/bin:$PS2DEV/iop/bin:$PS2DEV/dvp/bin:$PS2SDK/bin

COPY . /toolchain

RUN apt-get update &&\
  apt-get install -yqqq make bash gawk wget git patch && \
  apt-get install -yqqq pv pigz && \
  apt-get install -yqqq gcc g++ texinfo libmpc-dev libmpfr-dev libgmp-dev && \
  cd /toolchain && \
  ./toolchain.sh 1 && \
  ./toolchain.sh 2 && \
  ./toolchain.sh 3 && \
  ./toolchain.sh 4 && \
  ./toolchain.sh 5 && \
  ./toolchain.sh 6 && \
  rm -rf \
        /ps2dev/test.tmp \
        /toolchain/build \
        /var/lib/apt/lists/* \
        /tmp/*

WORKDIR /src
CMD ["/bin/bash"]
ENV GSKIT $PS2DEV/gsKit
