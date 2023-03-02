LOG_DIR1=/var/log/mysql/
LOG_DIR2=/var/log/
#DAYS_TO_HOLD=7
NOW=`date +%Y%m%d`

echo "Starting log cleanup process ..."

#find ${LOG_DIR} -name "combine.log."  -exec aws s3 mv {} s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/ \; >/dev/null 2>&1
#find ${LOG_DIR} -name "combined*.log" -exec aws s3 mv {} s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/ \; >/dev/null 2>&1
#find ${LOG_DIR} -name "*error.log"  -exec aws s3 mv {} s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/ \; >/dev/null 2>&1
#find ${LOG_DIR} -name "error*.log"  -exec aws s3 mv {} s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/ \; >/dev/null 2>&1
#find ${LOG_DIR} -name "error.log."  -exec aws s3 mv {} s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/ \; >/dev/null 2>&1
#find ${LOG_DIR} -name "pm2*.log" -exec aws s3 cp {}  s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/ \; >/dev/null 2>&1
#find ${LOG_DIR} -name ".log." -exec aws s3 cp {}  s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/ \; >/dev/null 2>&1
if [ -z LOG_DIR1 ]; then
    truncate -s 0 xxx.log
    rm -rf $LOG_DIR1/error.*.gz
    rm -rf $LOG_DIR1/slow.query*.gz
elif [ ]


mkdir /archive_foldername/"$(date +"%d-%m-%Y")"
cp -rfv /app/logs/* /archive_foldername/"$(date +"%d-%m-%Y")"
tar -zcvf /archive_foldername/"$(date +"%d-%m-%Y")".tar.gz  /archive_foldername/"$(date +"%d-%m-%Y")"
rm -rf /archive_foldername/"$(date +"%d-%m-%Y")"
aws s3 mv /archive_foldername/"$(date +"%d-%m-%Y")".tar.gz s3://bfl-logs-nodjs-apps/10.167.50.140_apps-logs/$(date +%F)/

# info about log folders which shld keep
# x folder a.log b.log c.log = *.log
# 
/usr/bin/truncate -s 0 /app/logs/pm2OutputFile.log
/usr/bin/truncate -s 0 /app/logs/pm2ErrorFile.log

echo "Log clean up completed"



1. archive - individual
    - tar.gz bundle : date.gz (mysql/{error.log,slow-query.log},apache2/{mod_evasive.log,access.log} )
2. upload
3. delete

# Set the array of log folders based on the environment
#if [ "$environment" == "production" ]; then
log_files=()

log_folders=("/var/log/mysql" "/var/log/apache2" "/var/www/html/pos/storage/logs" "/var/log")
For folder log_folders[@] then do
    if [ "$folder" == "/var/log/mysql" ]; then
     #log_folders=("error.log" "slow-query.log")
     printf "error.log\nslow-query.log\n" > logfiles.txt
     tar_name="mysql"
    elif [ "$folder" == "/var/log/apache2" ]; then
        printf "error.log\nmod_evasive.log\n" > logfiles.txt
        tar_name="apache"
    elif [ "$folder" == "/var/www/html/pos/storage/logs" ]; then
         printf "error.log\nmod_evasive.log\n" > logfiles.txt
    else 
        printf "error.log\nmod_evasive.log\n" > logfiles.txt
    fi
    #mysql
    cd $folder
    sudo tar -cvf ${tar_namem}.tar.gz -T logfiles.txt
    #Nothing
    mv ${tar_namem}.tar.gz /tmp/date
    truncate -s -0 error.log
    truncate slow-query.log
    rm -rf mysql.tar

    #Apache2
    cd /var/log/apache2
    sudo tar -zcvf apache2.tar.gz error.log  mod_evasive.log
    mv apache2.tar.gz /tmp/date
    truncate -s -0 error.log
    truncate slow-query.log

    #app
    cd /var/www/html/pos/storage/logs
    sudo tar -zcvf pos.tar.gz error.log  mod_evasive.log
    mv pos.tar.gz /tmp/date
    truncate -s -0 error.log
    truncate slow-query.log
done

cd /var/www/html/pos/storage/logs
tar pos.tar.gz /var/www/html/pos/storage/logs/*.log
mv pos.tar.gz /tmp/date
cd /tmp/date
tar final-$date.tar.gz ./* # includes apache.tar.gz & pos.tar.gz & mysql.tar...,
s3cmd put final.tar.gz s3://skdatabackup2/dbbackups/posdevlogs/
if [ $? == "0"] then
rm -rf /tmp/$date
fi
