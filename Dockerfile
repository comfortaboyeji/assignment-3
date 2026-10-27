FROM ubuntu:24.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       bash \
       coreutils \
       libc-bin \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/devops-tool

COPY app/app.sh ./app/app.sh

RUN chmod +x ./app/app.sh

ENTRYPOINT ["./app/app.sh"]
CMD ["help"]
