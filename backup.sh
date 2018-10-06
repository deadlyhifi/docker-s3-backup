#!/bin/bash

# S3 details
bucket="s3://$S3_BUCKET_NAME"
path=$S3_BUCKET_PATH

################################################################################
# Timestamp
stamp=`date +"%s_%d-%m-%Y_%H%M"`

# List all the databases
databases=`mysql -u $DB_USER -p$DB_PASSWORD -h $DB_CONTAINER -e "SHOW DATABASES;" | tr -d "| " | grep -v "\(Database\|information_schema\|performance_schema\|mysql\|test\)"`

# Feedback
echo -e "Dumping to \e[1;32m$bucket/$stamp/\e[00m"

# Loop the databases ###########################################################
for db in $databases; do

  # Define our filenames
  filename="$stamp-$db.sql.gz"
  tmpfile="/tmp/$filename"
  destination="$bucket/$path/$filename"

  # Feedback
  echo -e "\e[1;34m$db\e[00m"

  # Dump and zip
  echo -e "\e[0;35mCreating $tmpfile\e[00m"
  mysqldump -u $DB_USER -p$DB_PASSWORD -h $DB_CONTAINER --force --opt --databases "$db" | gzip -c > "$tmpfile"

  # Upload
  echo -e "\e[0;35m✩ uploading $i\e[00m"
  aws s3 cp $tmpfile $destination

  # Delete
  echo -e "\e[0;35mDeleting temporary file: $tmpfile\e[00m"
  rm -f "$tmpfile"

done;

# Loop the backup folders ######################################################
for folder in ${!FOLDER_*}; do
  # Define our filenames
  folderName=${!folder}
  folderPath=/data/${!folder}/
  filename="$stamp-$folderName.tar.gz"
  tmpfile="/tmp/$filename"
  destination="$bucket/$path/$filename"

  # Dump and zip
  echo -e "\e[0;35mCreating $tmpfile\e[00m"
  tar -cv "$folderPath" | gzip > "$tmpfile"

  # Upload
  echo -e "\e[0;35mUploading $i\e[00m"
  aws s3 cp $tmpfile $destination

  # Delete
  echo -e "\e[0;35mDeleting temporary file: $tmpfile\e[00m"
  rm -f "$tmpfile"

done

echo -e "\e[1;32m★ Job’s a good ’un\e[00m"
