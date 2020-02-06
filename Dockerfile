FROM alpine:3.11.3
RUN apk add --no-cache \
    tvheadend=4.2.8-r1

ARG APP_USER="hts"
RUN adduser -D -u 1359 "$APP_USER"
USER "$APP_USER"

ARG CONF_DIR="/home/$APP_USER/.hts"
VOLUME ["$CONF_DIR"]

ARG REC_DIR="/home/$APP_USER/rec"
RUN mkdir "$REC_DIR"
VOLUME ["$REC_DIR"]

EXPOSE 9981/tcp 9982/tcp
#      HTTP     HTSP

ENTRYPOINT exec tvheadend -C
