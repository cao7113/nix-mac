FROM ubuntu:24.04
# FROM debian:bullseye-20240701-slim

# To locally connect your container image to a repository, you must add this line
LABEL org.opencontainers.image.source https://github.com/cao7113/dot-tools/cloud/flyio/try

ENV PORT 8080

RUN apt-get update -y && \
    apt-get install -y \
    netcat-openbsd \
    net-tools \
    curl \
    iputils-ping \
    dnsutils \
    jq \
    postgresql-client && \
    apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app
RUN touch test-only
EXPOSE $PORT

# CMD ["ping", "-i", "5", "localhost"]
CMD nc -lkv -p $PORT
