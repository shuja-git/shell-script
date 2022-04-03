#!/bin/bash

#echo Catalogue setup
source components/common.sh
MAX_LENGTH=$(cat ${0} components/databases.sh | grep -v -w cat | grep STAT_CHECK | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1 )

if [ ${MAX_LENGTH} -lt 24 ]; then
    MAX_LENGTH=24
fi




# curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
 yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install Nodejs"

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 useradd roboshop &>>${LOG_FILE}
 STAT_CHECK $? "Add Application User"
fi

#
DOWNLOAD catalogue
rm -rf /home/roboshop/catalogue && mkdir -p /home/roboshop/catalogue && cp -r /tmp/catalogue-main/* /home/roboshop/catalogue &>>${LOG_FILE}
STAT_CHECK $? "Copy catalogue Contents"
cd /home/roboshop/catalogue && npm install &>>${LOG_FILE}
STAT_CHECK $? "Install Nodejs Dependencies"



#NOTE: We need to update the IP address of MONGODB Server in systemd.service file
#Now, lets set up the service with systemctl.

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
#-----------------------------------------------------------


#Nodejs catalogue

