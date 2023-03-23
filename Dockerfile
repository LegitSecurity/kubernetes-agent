FROM cgr.dev/chainguard/alpine-base:latest

RUN apk update; apk add --no-cache bash curl

WORKDIR /app

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x ./kubectl

HEALTHCHECK --interval=2m --start-period=1m CMD ps -ef | grep kubectl | grep -v grep || exit 1

ENTRYPOINT ["/app/kubectl", "proxy", "-p", "8001"]
