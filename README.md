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

## Quick start

```bash
docker run -d \
  --name Manager \
  -p 8080:8080 \
  -v /path/to/manager-data:/data \
  --restart=unless-stopped \
  ghcr.io/cub4no/managerio-docker:latest
```

Open Manager at:

```text
http://localhost:8080
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

Start it with:

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

## Backup

Before updating, create a backup from Manager:

1. Open your business.
2. Click **Backup**.
3. Save the backup file outside the container.

You can also stop the container and copy or snapshot the host folder mounted to `/data`.

## Updating

Make sure your data is stored outside the container and that you have a recent backup.

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
