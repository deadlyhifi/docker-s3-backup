# Docker S3 Backup

Backup your MySQL databases and folders into Amazon S3.

## docker-compose.yml

```
version: '3'

services:
  backup:
    image: deadlyhifi/docker-s3-backup
    environment:
      - AWS_ACCESS_KEY_ID=YOURACCESSKEY
      - AWS_SECRET_ACCESS_KEY=YOURSECRETACCESKEY
      - AWS_DEFAULT_REGION=your-region
      - S3_BUCKET_NAME=your-bucket-name
      - S3_BUCKET_PATH=your-bucket-path
      - CRON_SCHEDULE=0 * * * *
      - FOLDER_NAME_1=folder-to-upload
      - DB_CONTAINER=NAMEOFYOURDBCONTAINER
      - DB_USER=YOURDBUSER
      - DB_PASSWORD=YOURDBPASSWORD
    tty: true
    volumes:
      - .:/data:ro # use ro to make volume read-only
    restart: always
```

The `tty` is very important as that produces a console for the crontab to run in; the equivalent of `-t` on `docker run`. See https://docs.docker.com/compose/compose-file/#domainname-hostname-ipc-mac_address-privileged-read_only-shm_size-stdin_open-tty-user-working_dir.

### Folders

All your mounted folders will also be mounted into the `data` folder as read only. Relative to this point list the folders you wish to be backed up.

e.g.
FOLDER_UPLOADS=uploads
FOLDER_THEMES=themes
FOLDER_SOMETHING=else

### Databases

All your databases will be backed up, except the defaults created by MySQL/MariaDB.

`DB_CONTAINER` is the name of the database container as you name it in your `docker-compose` file. e.g. `db`

Note - `--single-transaction` is given which should only be used on InnoDB tables. ([details](https://dba.stackexchange.com/questions/87100/what-are-the-optimal-mysqldump-settings)).

# Info

- `0 * * * *` in `CRON_SCHEDULE` is every hour. Look at [Cron times](https://crontab.guru/) on how to set different schedules.
- Here's a list of [AWS regions](https://docs.aws.amazon.com/general/latest/gr/rande.html)
- Don’t forget to [expire your S3 Objects](https://aws.amazon.com/blogs/aws/amazon-s3-object-expiration/) or you could end up with a hefty bill.

# Thanks

- https://gist.github.com/2206527
- https://github.com/peterrus/docker-s3-cron-backup
- https://github.com/MorbZ/docker-cron
- https://stackoverflow.com/questions/37015624/how-to-run-a-cron-job-inside-a-docker-container

# Releases

1.0 - It works!
1.1 - Pressume InnoDB
1.1.1 - Correct docker-compose example
