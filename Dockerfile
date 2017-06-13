FROM corydodt/circus-base:0.1

RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
        python-dev \
        libffi-dev \
        openssl-dev \
    && apk add --no-cache \
        openssl \
    && pip install certbot \
    && apk del build-dependencies

COPY 00-letsrenew.ini /etc/circus.d/

RUN mkdir -p /etc/letsencrypt
