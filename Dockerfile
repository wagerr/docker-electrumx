FROM python:3.7-alpine3.9
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

COPY ./bin /usr/local/bin
COPY ./VERSION /tmp

RUN chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base openssl && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main leveldb-dev && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing rocksdb-dev && \
    pip install aiohttp pylru plyvel websockets python-rocksdb quark_hash && \
    git clone  https://github.com/wagerr/wagerr-electrumx-server.git WagerrElectrumX && \
    cd WagerrElectrumX && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV DAEMON_URL http://test:test@127.0.0.1:55003/

ENV DB_ENGINE rocksdb
ENV DB_DIRECTORY /data
ENV MAX_SEND=10000000
ENV BANDWIDTH_UNIT_COST=50000
ENV CACHE_MB=2000
ENV SERVICES=tcp://:31336,ssl://:31337,rpc://
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""
WORKDIR /data


EXPOSE 31336 31337 8000

CMD ["init"]