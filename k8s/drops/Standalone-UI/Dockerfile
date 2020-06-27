# docker build --force-rm -t kind-bootstrapper .
# docker run -it --rm -e KIND_EXPERIMENTAL_DOCKER_NETWORK=internal -v /var/run/docker.sock:/var/run/docker.sock kind-bootstrapper
FROM alpine:3.12.0 as builder

ENV KIND_VERSION=v0.8.1
ENV DOCKER_BINARY_VERSION=19.03.9

ADD https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64 /bin/kind
ADD https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_BINARY_VERSION}.tgz /

RUN chmod +x /bin/kind \
  && tar zxvf  /docker-${DOCKER_BINARY_VERSION}.tgz \
  && mv /docker/docker /bin/docker \
  && rm -rf /docker-${DOCKER_BINARY_VERSION}.tgz /docker


# this multi-stage dockerfile cuts the final image size in half
FROM alpine:3.12.0

COPY --from=builder /bin/kind /bin/kind
COPY --from=builder /bin/docker /bin/docker

ADD entrypoint.sh /entrypoint.sh
ENV KIND_EXPERIMENTAL_DOCKER_NETWORK="kind"
ENV KIND_NODE_IMAGE="kindest/node:v1.18.4"

ENTRYPOINT ["/entrypoint.sh"]