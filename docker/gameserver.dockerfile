FROM alpine:3.12

LABEL maintainer="kgtrey1"

RUN apk update

# Downloading and setting up artifacts.

ARG BASE_URI=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/
ARG ARTIFACT_VERSION=3184
ARG ARTIFACT_CHECKSUM=6123f9196eb8cd2a987a1dd7ff7b36907a787962

WORKDIR /altera/server

RUN wget "${BASE_URI}${ARTIFACT_VERSION}-${ARTIFACT_CHECKSUM}/fx.tar.xz" \
    && tar xf fx.tar.xz \
    && rm fx.tar.xz

# Downloading and setting up server data

ARG CFX_SERVER_DATA=https://github.com/citizenfx/cfx-server-data/archive/master.zip

WORKDIR /altera/server-data

RUN wget ${CFX_SERVER_DATA} \
    && unzip master.zip \ 
    && mv cfx-server-data-master/* . \
    && rm -rf master.zip cfx-server-data-master

# Copying Altera data into server data

ADD src/ /altera/server-data/

CMD sh /altera/server/run.sh +exec server.cfg