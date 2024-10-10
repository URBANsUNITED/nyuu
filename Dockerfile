FROM ghcr.io/linuxserver/baseimage-debian:bookworm

COPY ./root /

RUN \
  echo "**** download nyuu source ****" && \
  mkdir /usr/src/Nyuu && \
  curl -o \
    /tmp/nyuu.tar.gz -L \
    "https://github.com/animetosho/Nyuu/archive/refs/tags/v0.4.2.tar.gz" && \
  tar xf \
    /tmp/nyuu.tar.gz -C \
    /usr/src/Nyuu --strip-components=1 && \
  rm /tmp/nyuu.tar.gz && \
  echo "**** install packages ****" && \
  sed -i 's/main$/main non-free/' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    node-async \
    npm \
    make \
    g++ \
    rar \
    ca-certificates \
    xz-utils \
    mc \
    p7zip-full \
    nano \
    tmux && \
  apt-get clean all && \
  rm -rf /var/lib/apt/lists/* && \
  echo "**** download parpar ****" && \
  curl -o \
  /tmp/parpar.xz -L \
  "https://github.com/animetosho/ParPar/releases/download/v0.4.3/parpar-v0.4.3-linux-static-amd64.xz" && \
  xz -d \
    /tmp/parpar.xz && \
  mv /tmp/parpar /usr/bin/parpar && \
  chmod +x /usr/bin/parpar && \
  echo "**** build nyuu ****" && \
  cd /usr/src/Nyuu && \
  mv /patches/nyuu.js ./bin/ && \
  mv /patches/uploadmgr.js ./lib/ && \
  mv /patches/article.js ./lib/ && \
  mv /patches/help-full.txt ./ && \
  rmdir /patches/ && \
  sed -i "s/'User-Agent':/\/\/'User-Agent':/g" ./config.js && \
  npm install && \
  ln -s /usr/src/Nyuu/bin/nyuu.js /usr/bin/nyuu && \
  chmod +x /usr/bin/nyuu

# volumes
VOLUME [ "/config", "/output", "/storage" ]
