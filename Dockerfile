FROM ruby:2.3-alpine

MAINTAINER John Allen <john.allen@technekes.com>
MAINTAINER Jack Ross <jack.ross@technekes.com>

VOLUME /var/s3
ARG S3FS_VERSION=v1.79

RUN \
  cd /tmp && \

  apk --no-cache add wget ca-certificates && \

  wget "s3.amazonaws.com/aws-cli/awscli-bundle.zip" -O "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    apk --no-cache add groff less python && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \

  # install build related tools
  apk --no-cache add --virtual .build_deps \
    git \
    autoconf \
    automake \
    build-base \
    glib \
    glib-dev \
    libc-dev \
    libtool \
    linux-headers \
    openssl-dev \
    ruby-dev && \

  apk --no-cache add --virtual .s3fs_deps \
    fuse \
    alpine-sdk \
    automake \
    autoconf \
    libxml2-dev \
    fuse-dev \
    curl-dev \
    git \
    bash && \

  apk --no-cache add --virtual .gem_deps \
    postgresql-dev \
    sqlite-dev \
    libxml2-dev \
    libxslt-dev \
    tzdata && \

  # install s3fs
  cd /tmp && \
  git clone https://github.com/s3fs-fuse/s3fs-fuse.git && \
    cd s3fs-fuse && \
    git checkout tags/${S3FS_VERSION} && \
    ./autogen.sh && \
    ./configure --prefix=/usr && make && make install && \
    cd /tmp && \

  # install csvquote
  cd /tmp && \
  wget "https://github.com/dbro/csvquote/archive/master.zip" && \
    unzip master.zip && rm master.zip && \
    cd csvquote-master && \
    make && make install && \
    cd /tmp && \

  # install mdb-tools
  cd /tmp && \
  wget "https://github.com/brianb/mdbtools/archive/0.7.1.zip" && \
    unzip 0.7.1.zip && rm 0.7.1.zip && \
    cd mdbtools-0.7.1 && \
    autoreconf -i -f && \
    ./configure --disable-man && make && make install && \
    cd /tmp && \

  # install apk versions of tools
  apk --no-cache add \
    bash \
    coreutils \
    freetds \
    gawk \
    gzip \
    jq \
    postgresql-client \
    sed \
    gpgme && \

  apk --no-cache add \
    gnupg1 && \

  rm /etc/freetds.conf && \

  # symlink gsed to sed
  ln -s /bin/sed /bin/gsed && \

  #clean up
  # apk del build-base libtool autoconf automake glib-dev openssl && \
  rm -rf /tmp/*

COPY alpine/etc/freetds.conf /etc/

# override entry point from parent image
ENTRYPOINT []
