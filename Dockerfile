FROM technekes/awscli:latest

MAINTAINER John Allen <john.allen@technekes.com>

RUN \
  cd /tmp && \

  # install build related tools
  apk --no-cache add \
    build-base \
    openssl \
    libtool \
    autoconf \
    automake \
    glib-dev && \

  # install csvquote
  wget "https://github.com/dbro/csvquote/archive/master.zip" && \
  unzip master.zip && rm master.zip && \
  cd csvquote-master && \
  make && make install && \

  # install mdb-tools
  wget "https://github.com/brianb/mdbtools/archive/0.7.1.zip" && \
  unzip 0.7.1.zip && rm 0.7.1.zip && \
  cd mdbtools-0.7.1 && \
  autoreconf -i -f && \
  ./configure --disable-man && make && make install && \

  # install apk versions of tools
  apk --no-cache add \
    freetds \
    jq \
    postgresql-client \
    sed \
    gzip && \

  # symlink gsed to sed
  ln -s /bin/sed /bin/gsed && \

  #clean up
  apk del build-base libtool autoconf automake glib-dev openssl && \
  rm -rf /tmp/*

# override entry point from parent image
ENTRYPOINT []
