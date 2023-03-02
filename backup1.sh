#!/bin/bash

# Set the environment
environment=staging

# Set the array of log folders based on the environment
if [ "$environment" == "production" ]; then
    log_folders=("/home/splendornet/prod/_logs1" "/home/splendornet/prod/_logs2")
elif [ "$environment" == "staging" ]; then
    log_folders=("/var/log/apache2" "/var/www/html/pos/storage/logs")
else
    log_folders=("/home/splendornet/dev/_logs5" "/home/splendornet/dev/_logs6")
fi

# Set your AWS S3 bucket name
#bucket_name="skdatabackup2"
s3mainbucket="s3://skdatabackup2/dbbackups/posdevlogs/"

# Loop through each log folder
for folder in "${log_folders[@]}"
do
    # Find all files in the log folder that have the .log extension
    # log_files=$folder/*.gz 
    log_files=$folder/*.log
    log_zip=$folder/*.gz
    # Create a unique name for the zip file
    zip_file_name=$folder-$(date +%Y-%m-%d-%H-%M-%S).zip
   # zip_zip_name=$folder-$(date +%Y-%m-%d-%H-%M-%S-gz).zip

    # Zip the log files
    zip -r $zip_file_name $log_files $log_zip
#    zip -r $zip_file_name $zip_files
    # Archive the zip file to AWS S3
 #   s3cmd cp $zip_file_name s3://$bucket_name

  s3cmd put /var/log/.zip /var/www/html/pos/storage/.zip s3://skdatabackup2/dbbackups/posdevlogs/
  

#cd /var/www/html/pos/storage/
#for folder in "${log_folders[@]}"

#do
#         s3cmd  cp /var/www/html/pos/storage/*.zip ${s3mainbucket}
#	log_message "INFO" "File ${exportedfile} transferred to S3 "

#done
    # Loop through each log file and delete it
#    for log_file in $log_files
#    do
#        if [ -f $log_file ]
#        then
#            rm $log_file
#        fi
#    done

    # Remove the zip file after uploading to S3
    rm $zip_file_name

    echo "Log files have been archived to S3 and deleted from $folder"
done