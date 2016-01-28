FROM technekes/awscli:latest

MAINTAINER John Allen <john.allen@technekes.com>

RUN \
  apk add --update \
    freetds \
    jq \
    postgresql-client && \
  rm /var/cache/apk/*

# override entry point from parent image
ENTRYPOINT []
