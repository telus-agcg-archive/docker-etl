# ETL Utility

Provides access to commonly used ETL tools

# Libraries

* awscli
* freetds
* jq
* psql
* csvquote
* mdbtools
* sed (gsed)
* gzip

# Usage

For one off commands accessing one of the installed libraries.

```sh
docker run \
  --rm \
  technekes/etl \
  psql --help
```

In order to access AWS you will need to provide your credentials. Something along these lines should do:

```sh
docker run \
  --rm \
  --volume $HOME/.aws:/root/.aws \
  technekes/etl \
  aws help
```

It is more likely that you would use this images as a base for some ETL type work.

```Dockerfile
FROM technekes/etl:latest

COPY . /usr/src/app

CMD /usr/src/app/etl.sh
```
