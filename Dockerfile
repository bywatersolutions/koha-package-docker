ARG BASE_IMAGE

FROM $BASE_IMAGE

LABEL maintainer="Kyle M Hall <kyle@bywatersolutions.com>"

RUN apt-get update && apt-get -y install \
        wget \
        gnupg2 \
        && rm -rf /var/lib/apt/lists/*

ARG KOHA_VERSION
RUN echo "deb http://debian.koha-community.org/koha $KOHA_VERSION main" | tee /etc/apt/sources.list.d/koha.list
RUN cat /etc/apt/sources.list.d/koha.list

RUN wget -q -O- https://debian.koha-community.org/koha/gpg.asc | apt-key add -

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
