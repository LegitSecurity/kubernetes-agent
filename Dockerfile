FROM cgr.dev/chainguard/alpine-base:latest

ARG KUBECTL_CHECKSUM='7fe3a762d926fb068bae32c399880e946e8caf3d903078bea9b169dcd5c17f6d'


RUN apk update; apk add --no-cache bash curl

WORKDIR /app

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    echo "$(echo ${KUBECTL_CHECKSUM}) kubectl" | sha256sum -c && \
    chmod +x ./kubectl

RUN adduser -D -g '' legit-user
USER legit-user

HEALTHCHECK --interval=2m --start-period=1m CMD ps -ef | grep kubectl | grep -v grep || exit 1

ENTRYPOINT ["/app/kubectl", "proxy", "-p", "8001"]
