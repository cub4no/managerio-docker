FROM debian:trixie-slim

ARG MANAGER_VERSION=26.6.17.3647

LABEL org.opencontainers.image.title="managerio-docker" \
      org.opencontainers.image.description="Docker image for Manager.io Server (accounting software for small business)" \
      org.opencontainers.image.licenses="GPL-3.0-only" \
      org.opencontainers.image.source="https://github.com/cub4no/managerio-docker"

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        chromium-headless-shell \
        curl \
        libicu76; \
    ln -sfn /usr/bin/chromium-headless-shell /usr/bin/chromium-browser; \
    rm -rf /var/lib/apt/lists/*; \
    curl -fsSL "https://github.com/Manager-io/Manager/releases/download/${MANAGER_VERSION}/ManagerServer-linux-x64.tar.gz" -o /tmp/manager-server.tar.gz; \
    mkdir -p /opt/manager-server; \
    tar -xzf /tmp/manager-server.tar.gz -C /opt/manager-server; \
    rm -f /tmp/manager-server.tar.gz; \
    chmod +x /opt/manager-server/ManagerServer; \
    groupadd --system --gid 1000 manager; \
    useradd --system --uid 1000 --gid manager --home-dir /opt/manager-server --shell /usr/sbin/nologin manager; \
    mkdir -p /data; \
    chown -R manager:manager /data /opt/manager-server

USER manager

WORKDIR /opt/manager-server

VOLUME ["/data"]

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD curl -fsS http://127.0.0.1:8080/ || exit 1

CMD ["/opt/manager-server/ManagerServer", "-port", "8080", "-path", "/data"]
