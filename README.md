# docker-soundconverter

Soundconverter in a Docker container, Web UI

Used for conversion of audio files on the NAS itself

```
# Dockerfile
# run it with:

# source proxy.sh

docker rm docker-soundconverter-test
docker rmi docker-soundconverter
docker build -t mindcrime30/docker-soundconverter:0.0.1 .

# docker images
docker run --rm -p 5805:5800 --name docker-soundconverter-test mindcrime30/docker-soundconverter:0.0.1

```

Mount /config, /storage and /output as persistent volumes


# Sample

set environment variables to (examples!):
```
PUID=1020
PGID=1020
TZ=America/New_York
VM_STORAGE=/mnt/vm_storage
CONFIGFOLDER=/mnt/shared/configs
LOCALFOLDER=/mnt/local/config

# Docker-compose or portainer stacks:

---
version: '3.7'
services:
  soundconverter:
    image: mindcrime30/docker-soundconverter:latest
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    ports:
      - 5800:5800
    volumes:
      - ${VM_STORAGE}/soundconverter/config:/config
      - /mnt/files/music:/storage
      - ${VM_STORAGE}/soundconverter/output:/output


# Or with traefik
---
version: '3.7'
services:
  traefik:
    image: traefik:v1.7.16
    ports:
      - 80:80
      - 443:443
      - 8080:8080
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ${CONFIGFOLDER}/traefik/traefik.toml:/traefik.toml:ro
      - ${CONFIGFOLDER}/traefik/rules.toml:/rules.toml:ro
      - ${LOCALFOLDER}/traefik/acme.json:/acme.json
    labels:
      - traefik.enable=true
      - traefik.frontend.rule=Host:traefik.${LOCALDOMAIN}
      - traefik.port=8080
      - traefik.frontend.entryPoints=https,http
      - traefik.frontend.headers.SSLRedirect=true

  soundconverter:
    image: mindcrime30/docker-soundconverter:latest
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    volumes:
      - ${VM_STORAGE}/soundconverter/config:/config
      - /mnt/files/music:/storage
      - ${VM_STORAGE}/soundconverter/output:/output
    labels:
      - traefik.enable=true
      - traefik.frontend.rule=Host:soundconverter.${LOCALDOMAIN}
      - traefik.port=5800
      - traefik.frontend.entryPoints=https
      - traefik.frontend.headers.SSLRedirect=true
      
```
