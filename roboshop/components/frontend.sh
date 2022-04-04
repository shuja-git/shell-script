#!/bin/bash

#set -e
source components/common.sh



 yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "Nginx installation "
DOWNLOAD frontend

STAT_CHECK $? "Download Frontend "
rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "Remove Old HTML pages "
cd /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
 STAT_CHECK $? "Copying frontend content"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "Copy Nginx Config file"

  sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' \
          -e '/cart/ s/localhost/cart.roboshop.internal/' \
          -e '/user/ s/localhost/user.roboshop.internal/' \
          -e '/shipping/ s/localhost/shipping.roboshop.internal/' \
          -e '/payment/ s/localhost/payment/' /etc/nginx/default.d/roboshop.conf
  STAT_CHECK $? "Update Nginx Config file"

systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
STAT_CHECK $? "Restart Nginx"







