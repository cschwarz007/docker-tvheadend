# MCServer
Super small and simple tvheadend server.

## Running the server
```bash
docker run --detach --name tvheadend --publish 9981:9981 --mount type=bind,source=/path/to/dvb-devices,target=/path/to/dvb-devices --publish 9982:9982 hetsh/tvheadend
```

## Stopping the container
```bash
docker stop tvheadend
```

## Configuring
TVHeadend is configured via its [web interface](http://localhost:9981).
A configuration wizard will guide you through the initial setup if you run the server for the first time.

## Creating persistent storage
```bash
MP_CONF="/path/to/configuration"
MP_REC="/path/to/recordings"
mkdir -p "$MP_CONF" "$MP_REC"
chown -R 1359:1359 "$MP_CONF" "$MP_REC"
```
`1359` is the numerical id of the user running the server (see Dockerfile).
Start the server with the additional mount flags:
```bash
docker run --mount type=bind,source=/path/to/configuration,target=/home/hts/.hts --mount type=bind,source=/path/to/recordings,target=/home/hts/rec ...
```

## Automate startup and shutdown via systemd
```bash
systemctl enable tvheadend --now
```
The systemd unit can be found in my [GitHub](https://github.com/Hetsh/docker-tvheadend) repository.
By default, the systemd service assumes `/srv/hts/conf` and `/srv/hts/rec` for persistent storage.

## Fork Me!
This is an open project (visit [GitHub](https://github.com/Hetsh/docker-tvheadend)). Please feel free to ask questions, file an issue or contribute to it.
