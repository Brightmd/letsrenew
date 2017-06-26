FROM corydodt/circus-base:0.1

ENV letsrenew_home=/opt/letsrenew
RUN mkdir -p $letsrenew_home
WORKDIR $letsrenew_home
COPY requirements.txt $letsrenew_home

RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
        python-dev \
        libffi-dev \
        openssl-dev \
    && apk add --no-cache \
        openssl \
    && pip install -r requirements.txt \
    && apk del build-dependencies

COPY 00-letsrenew.ini /etc/circus.d/
COPY letsrenew $letsrenew_home

RUN mkdir -p /etc/letsencrypt
