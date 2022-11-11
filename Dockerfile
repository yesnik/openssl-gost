FROM debian:bullseye-slim

RUN apt-get update && apt-get install build-essential wget unzip -y

# Install OpenSSL
# Instruction: https://wiki.openssl.org/index.php/Compilation_and_Installation
# OpenSSL 1.1.0 changed the behavior of install rules. You should specify both --prefix and --openssldir
# to ensure make install works as expected.
ARG PREFIX="/usr/local"
ARG OPENSSL_DIR="${PREFIX}/ssl"
ARG OPENSSL_VERSION="OpenSSL_1_1_1s"
ARG OPENSSL_SHA256="aa76dc0488bc67f5c964d085e37a0f5f452e45c68967816a336fa00f537f5cc5"
# URL: https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_1_1s.zip
RUN cd /usr/local/src \
  && wget "https://github.com/openssl/openssl/archive/refs/tags/${OPENSSL_VERSION}.zip" -O "${OPENSSL_VERSION}.zip" \
  && echo "$OPENSSL_SHA256" "${OPENSSL_VERSION}.zip" | sha256sum -c - \
  && unzip "${OPENSSL_VERSION}.zip" -d ./ \
  && cd "openssl-${OPENSSL_VERSION}" \
  && ./config --prefix=${PREFIX} --openssldir=${OPENSSL_DIR} \
  && make install \
  && mv /usr/bin/openssl /root/ \
  && ln -s ${PREFIX}/bin/openssl /usr/bin/openssl \
  # create the necessary links and cache to the most recent shared libraries found \
  # in the directories specified on the command line, in the file `/etc/ld.so.conf`
  && ldconfig


# Install GOST-engine for OpenSSL
# Instruction: https://github.com/gost-engine/engine/blob/openssl_1_1_1/INSTALL.md
ARG ENGINES_DIR="/usr/local/lib/engines-1.1"
ARG OPENSSL_LIB_DIR="/usr/local/lib"
# Commit May 20, 2022
# URL: https://github.com/gost-engine/engine/archive/739f957615eb33a33a6485ae7cf29c7c679fd59a.zip
ARG GOST_ENGINE_VERSION=739f957615eb33a33a6485ae7cf29c7c679fd59a
ARG GOST_ENGINE_SHA256="99e047a239b374b62edd5e543cd76ac15f85b58adadc18f59f962e65008d126d"
RUN apt-get install cmake -y \
  && cd /usr/local/src \
  && wget "https://github.com/gost-engine/engine/archive/${GOST_ENGINE_VERSION}.zip" -O gost-engine.zip \
  && echo "$GOST_ENGINE_SHA256" gost-engine.zip | sha256sum -c - \
  && unzip gost-engine.zip -d ./ \
  && cd "engine-${GOST_ENGINE_VERSION}" \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release \
   -DOPENSSL_ROOT_DIR=${OPENSSL_LIB_DIR} -DOPENSSL_LIBRARIES=${OPENSSL_LIB_DIR} -DOPENSSL_ENGINES_DIR=${ENGINES_DIR} .. \
  && cmake --build . --config Release \
  && make install \
  && rm -rf "/usr/local/src/*"

COPY ./gost-engine.conf /usr/local/src/
# Edit openssl.conf to enable GOST engine
RUN sed -i '5i openssl_conf=openssl_def' ${OPENSSL_DIR}/openssl.cnf \
  && cat /usr/local/src/gost-engine.conf >> ${OPENSSL_DIR}/openssl.cnf


# Install curl
# Instruction: https://curl.se/docs/install.html
# URL: https://curl.se/download/curl-7.86.0.zip
ENV LD_LIBRARY_PATH="${PREFIX}/lib"
ARG CURL_VERSION=7.86.0
ARG CURL_SHA256="08fabf745991f7af4fb1f6675c9a0141bb6c01c6ad4474b582fbec75a44cc5f1"
RUN cd /usr/local/src \
  && wget "https://curl.haxx.se/download/curl-${CURL_VERSION}.zip" -O "curl-${CURL_VERSION}.zip" \
  && echo "$CURL_SHA256" "curl-${CURL_VERSION}.zip" | sha256sum -c - \
  && unzip "curl-${CURL_VERSION}.zip" \
  && cd "curl-${CURL_VERSION}" \
  && ./configure --with-openssl \
  && make install \
  && ln -s /usr/local/curl/bin/curl /usr/bin/curl \
  && rm -rf "/usr/local/src/*"
