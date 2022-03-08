LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}

STAT_CHECK(){
  if [ "${1}" -ne 0 ]; then
    echo -e "\e[1m${2} - \e[1;31mFailed\e[0m"
    exit 1
  else
    echo -e "\e[1m${2} - \e[1;32mSuccess\e[0m"
  fi
}
# setting hostname for child components
set-hostname -skip-apply ${COMPONENT}

DOWNLOAD (){
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
  STAT_CHECK $? "Download ${1} code"
  cd /tmp && unzip -o /tmp/${1}.zip &>>${LOG_FILE}
  STAT_CHECK $? "Extracting ${1} Code"
}

Nodejs() {
component=${1}
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install NodeJS"

id roboshop &>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG_FILE}
  STAT_CHECK $? "Add Application User"

fi

DOWNLOAD ${component}
rm -rf /home/roboshop/${component} && mkdir -p /home/roboshop/${component} && cp -r /tmp/${component}-main/* /home/roboshop/${component} &>>${LOG_FILE}
STAT_CHECK $? "Copy ${component} contents"

cd /home/roboshop/${component} && npm install --unsafe-perm &>>${LOG_FILE}
STAT_CHECK $? "Install NodeJS dependencies"

chown roboshop:roboshop -R /home/roboshop

sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/'
       -e  's/REDIS_ENDPOINT/redis.roboshop.internal/'
       -e  's/MONGO_ENDPOINT/mongo.roboshop.internal' /home/roboshop/${component}/systemd.service &>>{LOG_FILE} && mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service &>>{LOG_FILE}
STAT_CHECK $? "Update systemd Config file"

systemctl daemon-reload &>>{LOG_FILE} && systemctl start ${component} &>>{LOG_FILE} && systemctl enable ${component} &>>${LOG_FILE}
STAT_CHECK $? "start ${component} Service"

}




