#!/bin/bash

#echo Catalogue setup
source components/common.sh


NODEJS catalogue


## curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
# yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
#STAT_CHECK $? "Install Nodejs"
#
#id roboshop &>>${LOG_FILE}
#if [ $? -ne 0 ]; then
# useradd roboshop &>>${LOG_FILE}
# STAT_CHECK $? "Add Application User"
#fi
#
##
#DOWNLOAD catalogue
#rm -rf /home/roboshop/catalogue && mkdir -p /home/roboshop/catalogue && cp -r /tmp/catalogue-main/* /home/roboshop/catalogue &>>${LOG_FILE}
#STAT_CHECK $? "Copy catalogue Contents"
#cd /home/roboshop/catalogue && npm install --unsafe-perm &>>${LOG_FILE}
#STAT_CHECK $? "Install Nodejs Dependencies"
#
#chown roboshop:roboshop -R /home/roboshop
#
#
##NOTE: We need to update the IP address of MONGODB Server in systemd.service file
##Now, lets set up the service with systemctl.
#
#sed -i 's/MONGO_DNSNAME/mongo.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>${LOG_FILE} && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
#STAT_CHECK $? "Update SystemD Config file"
#
## mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
#systemctl daemon-reload &>>${LOG_FILE} && systemctl start catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
#STAT_CHECK $? "Start Catalogue Service"
#
#-----------------------------------------------------------




