#! /bin/bash

DOWNLOAD(){
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
  STAT_CHECK $? "Download ${1} code"
  cd /tmp
  unzip -o /tmp/${1}.zip &>>${LOG_FILE}
  STAT_CHECK $? "Extract ${1} code"

}


STAT_CHECK(){
  SPACE=""
  LENGTH=$(echo $2 | awk '{print length}')
# echo "LENGTH= " $LENGTH
  LEFT=$((${MAX_LENGTH}-${LENGTH}))
#  echo "LEFT= " $LEFT
  while [ $LEFT -gt 0 ]; do
    SPACE=$(echo -n "${SPACE}")
    LEFT=$((${LEFT}-1))
  done
#  echo $SPACE
#  exit
 if [ $1 -ne 0 ]; then
   echo -e "\e[1m${2}${SPACE} - \e[1;31mFailed\e[0m"
   exit 1
 else
   echo -e "\e[1m${2}${SPACE} - \e[1;32mSuccess\e[0m"
 fi

}
LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}

set-hostname -skip-apply ${COMPONENT}



#===============================================
#LOG_FILE=/tmp/roboshop.log
#rm -f ${LOG_FILE}
#
#STAT_CHECK(){
#  if [ "${1}" -ne 0 ]; then
#    echo -e "\e[1m${2} - \e[1;31mFailed\e[0m"
#    exit 1
#  else
#    echo -e "\e[1m${2} - \e[1;32mSuccess\e[0m"
#  fi
#}
## setting hostname for child components
#set-hostname -skip-apply ${COMPONENT}
#
#SYSTEMD_SETUP() {
#  chown roboshop:roboshop -R /home/roboshop
#
#  sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' \
#         -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
#         -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' \
#         -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
#          -e 's/CARTENDPOINT/cart.roboshop.internal/' \
#          -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service &>>${LOG_FILE}
#  STAT_CHECK $? "Update systemd Config file"
#
#  systemctl daemon-reload &>>{LOG_FILE} && systemctl start ${component} &>>{LOG_FILE} && systemctl enable ${component} &>>${LOG_FILE}
#  STAT_CHECK $? "start ${component} Service"
#
#
#
#}
#
#APP_USER_SETUP(){
#id roboshop &>${LOG_FILE}
#if [ $? -ne 0 ]; then
#  useradd roboshop &>>${LOG_FILE}
#  STAT_CHECK $? "Add Application User"
#
#fi
#
#DOWNLOAD ${component}
#
#}
#
#DOWNLOAD (){
#  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
#  STAT_CHECK $? "Download ${1} code"
#  cd /tmp && unzip -o /tmp/${1}.zip &>>${LOG_FILE}
#  STAT_CHECK $? "Extracting ${1} Code"
#  rm -rf /home/roboshop/${component} && mkdir -p /home/roboshop/${component} && cp -r /tmp/${component}-main/* /home/roboshop/${component} &>>${LOG_FILE}
#  STAT_CHECK $? "Copy ${component} contents"
#
#
#}
#
#Nodejs() {
#component=${1}
#yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
#STAT_CHECK $? "Install NodeJS"
#
#APP_USER_SETUP
#
#
#
#cd /home/roboshop/${component} && npm install --unsafe-perm &>>${LOG_FILE}
#STAT_CHECK $? "Install NodeJS dependencies"
#
#SYSTEMD_SETUP
#
#}
#JAVA() {
#component=${1}
##Install Maven, This will install Java too
# yum install maven -y &>>${LOG_FILE}
# STAT_CHECK $? "Installing Maven"
#
# APP_USER_SETUP
#
#
#
#
#cd /home/roboshop/${component} && mvn clean package &>>${LOG_FILE} && mv target/${component}-1.0.jar ${component}.jar &>>${LOG_FILE}
#STAT_CHECK $? "compile the Java code"
#
#SYSTEMD_SETUP
#
#}
#
#
#
