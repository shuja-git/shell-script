#!/bin/bash

#The frontend is the service in RobotShop to serve the web content over Nginx.
#
#To Install Nginx.
#
## yum install nginx -y
## systemctl enable nginx
## systemctl start nginx
#Let's download the HTML content that serves the RoboSHop Project UI and deploy under the Nginx path.
#
## curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
#Deploy in Nginx Default Location.
#
## cd /usr/share/nginx/html
## rm -rf *
## unzip /tmp/frontend.zip
## mv frontend-main/* .
## mv static/* .
## rm -rf frontend-master static README.md
## mv localhost.conf /etc/nginx/default.d/roboshop.conf
#Finally restart the service once to effect the changes.
#
## systemctl restart nginx
#--------------------------------
echo Frontend setup

source components/common.sh

#To Install Nginx. and redirect output and if any errors also coming then that also
#redirecting to same file
yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "Nginx installation "
#if [ $? -ne 0 ]; then
#  echo -e "\e[1;31mNginx install failed"
#  exit
#fi
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
STAT_CHECK $? "Dwonload frontend "
#if [ $? -ne 0 ]; then
#  echo -e "\e[1;31mDownload frontend failed\e[0m"
#  exit
#fi

#cd /usr/share/nginx/html
#rm -rf *
rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "Removing old HTML pages"

cd /tmp && unzip /tmp/frontend.zip &>>${LOG_FILE}
STAT_CHECK $? "Extracting frontend contents"

#mv frontend-main/* .
#mv static/* .
cd /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
STAT_CHECK $? "Copying frontend content"

#rm -rf frontend-master static README.md
#mv localhost.conf /etc/nginx/default.d/roboshop.conf
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "Update Nginx Config file"

systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
STAT_CHECK $? "Restart Nginx"








