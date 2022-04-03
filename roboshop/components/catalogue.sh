#!/bin/bash

echo Catalogue setup
source components/common.sh
MAX_LENGTH=$(cat ${0} components/databases.sh | grep -v cat | grep STAT_CHECK | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1 )




# curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
 yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install Nodejs"

 useradd roboshop &>>${LOG_FILE}
STAT_CHECK $? "Add Application User"
#
DOWNLOAD catalogue
#$ curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
#$ cd /home/roboshop
#$ unzip /tmp/catalogue.zip
#$ mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install


#NOTE: We need to update the IP address of MONGODB Server in systemd.service file
#Now, lets set up the service with systemctl.

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
#-----------------------------------------------------------


Nodejs catalogue

