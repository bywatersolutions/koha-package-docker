FROM debian:stretch-slim

LABEL maintainer="Kyle M Hall <kyle@bywatersolutions.com>"

ARG KOHA_VERSION=19.05

RUN echo "deb http://debian.koha-community.org/koha $KOHA_VERSION main" | tee /etc/apt/sources.list.d/koha.list

RUN apt-get update && apt-get --no-install-recommends -y --allow-unauthenticated install \
        koha-common \
        && a2dismod mpm_event \
        && apt-get install -f \
        && rm -rf /var/lib/apt/lists/* \
        && a2enmod rewrite \
        && a2enmod cgi

WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
CMD /app/entrypoint.sh
