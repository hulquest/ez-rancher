# docker build -t docker-proxy:2.1.4 .
FROM haproxy:1.9-alpine

EXPOSE 2375
ENV ALLOW_RESTARTS=0 \
    AUTH=0 \
    BUILD_POST=0 \
    COMMIT=0 \
    CONFIGS=0 \
    CONTAINERS=0 \
    CONTAINERS_POST=0 \
    CONTAINERS_DELETE=0 \
    DISTRIBUTION=0 \
    EVENTS=1 \
    EXEC=0 \
    IMAGES=0 \
    IMAGES_POST=0 \
    INFO=0 \
    NETWORKS=0 \
    NODES=0 \
    PING=1 \
    PLUGINS=0 \
    POST=0 \
    SECRETS=0 \
    SERVICES=0 \
    SERVICES_POST=0 \
    SESSION=0 \
    SWARM=0 \
    SYSTEM=0 \
    TASKS=0 \
    VERSION=1 \
    VOLUMES=0 \
    VOLUMES_POST=0 \
    LOGS=0
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
