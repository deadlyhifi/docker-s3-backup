FROM alpine:latest

COPY cron.sh /
COPY backup.sh /

RUN \
    mkdir -p /aws && \
    apk -Uuv add bash groff less python py-pip && \
    pip install awscli && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/* && \
    chmod +x /cron.sh /backup.sh

ENTRYPOINT /cron.sh
