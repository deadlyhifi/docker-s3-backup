# Docker S3 Backup

Backup your MySQL database and backup your files into Amazon S3.

## docker-compose.yml

```
version: '3'

services:
  backup:
    image: docker-s3-backup
    environment:
      - AWS_ACCESS_KEY_ID=YOURACCESSKEY
      - AWS_SECRET_ACCESS_KEY=YOURSECRETACCESKEY
      - AWS_DEFAULT_REGION=your-region
      - S3_BUCKET_NAME=your-bucket-name
      - S3_BUCKET_PATH=your-bucket-path
      - CRON_SCHEDULE=* * * * *
      - FOLDER_FOLDER_1=folder-to-upload
    tty: true
    volumes:
      - .:/data:ro # use ro to make volume read-only
    restart: always
```

The `tty` is very important as that produces a console for the crontab to run in; the equivalent of `-t` on `docker run`. See https://docs.docker.com/compose/compose-file/#domainname-hostname-ipc-mac_address-privileged-read_only-shm_size-stdin_open-tty-user-working_dir.

# Info

- `* * * * *` in `CRON_SCHEDULE` is every minute. Look at [Cron times](https://crontab.guru/) on how to set different schedules.
- Here's a list of [AWS regions](https://docs.aws.amazon.com/general/latest/gr/rande.html)

# Thanks

https://gist.github.com/2206527
https://github.com/peterrus/docker-s3-cron-backup
https://github.com/MorbZ/docker-cron
https://stackoverflow.com/questions/37015624/how-to-run-a-cron-job-inside-a-docker-container
