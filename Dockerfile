FROM library/alpine:20200319
RUN apk add --no-cache \
    tvheadend=4.2.8-r2

# App user
ARG APP_USER="tvheadend"
ARG APP_UID=1359
ARG APP_GID=986
RUN sed -i "s|$APP_USER:x:100:65533|$APP_USER:x:$APP_UID:$APP_GID|" /etc/passwd && \
    sed -i "s|video:x:27|video:x:$APP_GID|" /etc/group

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
