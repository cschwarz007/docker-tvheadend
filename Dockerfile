FROM amd64/alpine:20220715
RUN apk add --no-cache \
        tvheadend=4.3-r1

# App user
ARG APP_USER="tvheadend"
ARG APP_UID=1026
ARG APP_GID=100
RUN sed -i "s|$APP_USER:x:[0-9]\+:[0-9]\+|$APP_USER:x:$APP_UID:$APP_GID|" /etc/passwd && \
    sed -i "s|video:x:[0-9]\+|video:x:$APP_GID|" /etc/group

# Volumes
ARG HOME_DIR="/usr/share/tvheadend"
ARG DATA_DIR="/tvheadend-data"
RUN mkdir "$HOME_DIR/.hts" && \
    ln -s "$DATA_DIR" "$HOME_DIR/.hts/tvheadend"
VOLUME ["$DATA_DIR"]

#      HTTP     HTSP
EXPOSE 9981/tcp 9982/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT exec tvheadend -C
