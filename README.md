# managerio-docker

A Docker image for **[Manager.io](https://www.manager.io) Server** — accounting software for small business.

## Images

Available from GitHub Container Registry and Docker Hub:

```text
ghcr.io/cub4no/managerio-docker:latest
docker.io/cub4no/managerio-docker:latest
```

You can also pin a specific Manager.io Server version:

```text
ghcr.io/cub4no/managerio-docker:26.6.17.3647
docker.io/cub4no/managerio-docker:26.6.17.3647
```

Check the [Manager.io releases page](https://github.com/Manager-io/Manager/releases) for available versions.

## Requirements

- Docker 24+
- Docker Compose v2, if using the Compose example

## Supported architectures

This image is intended for:

```text
linux/amd64
```

Manager.io Server's Linux tarball used by this image is the upstream `linux-x64` release.

## Quick start

```bash
mkdir -p /path/to/manager-data
sudo chown -R 1000:1000 /path/to/manager-data

docker run -d \
  --name Manager \
  -p 8080:8080 \
  -v /path/to/manager-data:/data \
  --restart=unless-stopped \
  ghcr.io/cub4no/managerio-docker:latest
```

See [Security](#security) for details about data directory ownership.

Open Manager at:

```text
http://localhost:8080
```

The container always listens on port `8080`. To expose a different host port, change only the left side of the port mapping:

```bash
-p 9090:8080
```

## Docker Compose

```yaml
services:
  manager:
    image: ghcr.io/cub4no/managerio-docker:latest
    container_name: Manager
    ports:
      - "8080:8080"
    volumes:
      - ./data:/data
    restart: unless-stopped
```

Before starting it for the first time with a bind mount, prepare the data directory:

```bash
mkdir -p ./data
sudo chown -R 1000:1000 ./data
```

Then start it with:

```bash
docker compose up -d
```

## Data persistence

Manager stores its data in `/data` inside the container.

Always mount `/data` to a host folder or Docker volume so your business data survives container updates or recreation.

Examples:

```bash
-v /srv/manager-data:/data
```

or:

```bash
-v manager-data:/data
```

## Security

This image runs **Manager.io Server as a non-root user** (`UID 1000`, `GID 1000`).

Docker-managed volumes typically work without additional configuration.

If you use a bind mount, or if you are migrating existing data from another image that ran as a different user, make sure the data is writable by `1000:1000` before starting this container.

For a bind mount:

```bash
sudo chown -R 1000:1000 /path/to/manager-data
```

For a Docker-managed volume:

```bash
docker run --rm \
  -v manager-data:/data \
  ubuntu:noble \
  chown -R 1000:1000 /data
```

Run this only once for existing or migrated volumes that have incorrect ownership.

The container intentionally does **not** modify ownership of mounted data at startup. If permissions are incorrect, it will fail to start rather than changing files on the host.

## Backup

Before updating, create a backup from Manager:

1. Open your business.
2. Click **Backup**.
3. Save the backup file outside the container.

You can also stop the container and copy or snapshot the host folder mounted to `/data`.

## Updating

Make sure your data is stored outside the container and that you have a recent backup.

With Docker Compose:

```bash
docker compose pull
docker compose up -d
```

With `docker run`:

```bash
docker pull ghcr.io/cub4no/managerio-docker:latest
docker stop Manager
docker rm Manager
docker run -d \
  --name Manager \
  -p 8080:8080 \
  -v /path/to/manager-data:/data \
  --restart=unless-stopped \
  ghcr.io/cub4no/managerio-docker:latest
```

## License

This repository is licensed under **GPL-3.0-only**. See [`LICENSE`](./LICENSE).

Manager.io Server is created by [Manager.io](https://www.manager.io) and is distributed under its own license terms.
