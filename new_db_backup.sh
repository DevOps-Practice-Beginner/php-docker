#!/bin/bash
#Parameters : DEV/LIVE [ Default is DEV ]

#1. Connect to db server 2. Get list of databases [ hardcoded for now ]
#3. For each database
#4. export the databae in file of format
#5. put the file on s3
#6. send email with list of databases exported.

log_message()
{
	msgtype=$1
	msg=$2
	echo "`date +%Y%m%d-%H:%M:%S` ${msgtype} ${msg}"
}

setupdbconn()
{
	dbenv=$1
	case ${dbenv} in
	"DEV" )
		log_message "INFO" "Setting up DEV db connection "
		DBUSER="myfamilymartpos"
		DBHOST="localhost"
		;;
#	"LIVE" )
#		log_message "INFO" "Setting up LIVE db connection "
#		DBUSER="dbbackup"
#		DBHOST="3.228.242.88"
#		;;
#	"B2C" )
#		log_message "INFO" "Setting up B2C LIVE db connection "
#		DBUSER="root"
#		DBHOST="54.147.157.97"
#		;;
#       "MFMPOSDEV" )
#               log_message "INFO" "Setting up MFMPOSDEV DEV db connection "
#               DBUSER=""
#               DBHOST="54.147.157.97"
#               ;;

	*)
		log_message "ERR" "Invalid Database environment. Has to be one of DEV or LIVE"
		exit 1
		;;
	esac
}

exportdb()
{
	schemaname=$1
	exportfile=$2
	log_message "INFO" "Exporting schema ${schemaname} to ${exportfile}"

	if [ $schemaname == "myfamilymartpos" ]
	then
#		mysqldump --column-statistics=0  -u ${DBUSER} -h ${DBHOST} -R -P3306  ${schemaname} --routines  > ${exportfile}
		mysqldump --no-tablespaces -u ${DBUSER} -h ${DBHOST} -R -P3306  ${schemaname} --routines  > ${exportfile}
	else
		mysqldump -u ${DBUSER} -h ${DBHOST} -R -P3306  ${schemaname} --routines  > ${exportfile}
	fi

	log_message "INFO" "Exported ${schemaname} to ${exportfile}"
	log_message "INFO" "`ls -l ${exportfile}`"
	gzip -f ${exportfile}
	log_message "INFO" "Compressed ${exportfile}"

}




exportdt=`date +%Y%m%d`
exportdir=/home/ubuntu/dbexportfiles
devschemalist="myfamilymartpos"
#devschemalist=""
liveschemalist="myfamilymartpos"
#b2cliveschemalist="snapkirana_live"
s3mainbucket="s3://skdatabackup2/dbbackups"

log_message "INFO" "Processing DEV schemas for ${exportdt}"
export MYSQL_PWD="AzDSfdsUrWlKs"
	setupdbconn "DEV"
for i in ${devschemalist}
do
	log_message "INFO" "Backup of schema ${i} started"
	exportfilenm=${exportdir}/${exportdt}_${i}_dev.sql
	exportdb ${i} ${exportfilenm}
	log_message "INFO" "Backup of schema ${i} completed"
	log_message "INFO" "`ls -l $exportdir`"
done

#log_message "INFO" "DEV schemas completed"

#log_message "INFO" "Processing LIVE schemas for ${exportdt}"
#export MYSQL_PWD="ci80foLi8s"
#	setupdbconn "LIVE"
#for livschema in ${liveschemalist}
#do
#	log_message "INFO" "Backup of schema ${livschema} started"
#	exportfilenm=${exportdir}/${exportdt}_${livschema}_live.sql
#	exportdb ${livschema} ${exportfilenm}
#	log_message "INFO" "Backup of schema ${livschema} completed"
#done
#log_message "INFO" "LIVE schemas completed"

#log_message "INFO" "Processing B2C LIVE schemas for ${exportdt}"
#export MYSQL_PWD=Excel@sk1
#	setupdbconn "B2C"
#for livschema in ${b2cliveschemalist}
#do
#	log_message "INFO" "Backup of schema ${livschema} started"
#	exportfilenm=${exportdir}/${exportdt}_${livschema}.sql
#	exportdb ${livschema} ${exportfilenm}
#	log_message "INFO" "Backup of schema ${livschema} completed"
#done
#log_message "INFO" "B2C LIVE schemas completed"


log_message "INFO" "Local backup completed...Transferring to s3 to bucket ${s3mainbucket}"

cd ${exportdir}
for exportedfile in `ls ${exportdt}*.sql.gz`
do
	s3cmd put ${exportedfile} ${s3mainbucket}/${exportdt}/${exportedfile}
	log_message "INFO" "File ${exportedfile} transferred to S3 "
	rm ${exportedfile}
done

log_message "INFO" "Db backups transferred to S3......Listing below ....  "
s3cmd ls ${s3mainbucket}/${exportdt}/

### End of File ###