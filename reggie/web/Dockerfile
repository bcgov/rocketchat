FROM image-registry.apps.klab.devops.gov.bc.ca/jason-dev/caddy:latest

ENV INSTALL_PATH /srv
ENV SUMMARY="Reggie Web ${APP_VERSION}"  \
    DESCRIPTION="Reggie Web ${APP_VERSION} served from Caddy"
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

LABEL summary="$SUMMARY" \
    description="$DESCRIPTION"

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY build/ $INSTALL_PATH

EXPOSE 2015

