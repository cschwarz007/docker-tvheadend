FROM alpine:3.11.3
RUN apk add --no-cache \
    tvheadend=4.2.8-r1

EXPOSE 9981/tcp 9982/tcp
#      HTTP   HTTPS

ENTRYPOINT exec tvheadend
