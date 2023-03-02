#!/bin/bash

# Set the environment for the folder you want to take backup

environment=staging

# Set the array of log folders based on the environment
if [ "$environment" == "production" ]; then
    log_folders=("/home/splendornet/prod/_logs1" "/home/splendornet/prod/_logs2")
elif [ "$environment" == "staging" ]; then
    log_folders=("/var/log/apache2" "/var/log/mysql" "/var/www/html/ecomm-new/storage/logs")
else
    log_folders=("/home/splendornet/dev/_logs5" "/home/splendornet/dev/_logs6")
fi

# Set your AWS S3 bucket name

s3mainbucket="s3://skdatabackup2/dbbackups/posdevlogs/"

# Loop through each log folder
for folder in "${log_folders[@]}"
do
    
    log_files=$folder/*.log
    log_zip=$folder/*.gz
    
    # Create a unique name for the zip file
    
    zip_file_name=$folder-$(date +%Y-%m-%d-%H-%M-%S).zip
   

    # Zip the log files
    
    zip -r $zip_file_name $log_files $log_zip

# Copy zip files from folders to s3 bucket 

 s3cmd put /var/log/*.zip /var/www/html/pos/storage/*.zip s3://skdatabackup2/dbbackups/posdevlogs/
  
# Removes log_files from the log folders
    sudo rm -r /var/www/html/ecomm-new/storage/logs/*.log
    sudo rm -r /var/www/html/ecomm-new/storage/logs/*.gz 

# Loop through each log file and delete it
#    for log_file in $log_files
#    do
#        if [ -f $log_file ]
#        then
#            rm $log_file
#        fi
#    done

    # Removes the zip file after uploading to S3
    
#    rm $zip_file_name

    #Prints message that log files have been archived to s3 and deleted from log folders
    
    echo "Log files have been archived to S3 and deleted from $folder"
done