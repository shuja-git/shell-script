#! /bin/bash

MAX_LENGTH=$(cat ${0} components/databases.sh | grep -v -w cat | grep STAT_CHECK | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1 )

if [ ${MAX_LENGTH} -lt 24 ]; then
    MAX_LENGTH=24
fi

SYSTEMD_SETUP(){
   chown roboshop:roboshop -R /home/roboshop

   sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' \
           -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
           -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' \
           -e's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
           -e 's/CARTENDPOINT/cart.roboshop.internal/' \
           -e 's/DBHOST/mysql.roboshop.internal/' \
           -e 's/CARTHOST/cart.roboshop.internal/' \
           -e 's/USERHOST/user.roboshop.internal/' \
           -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
            -e 's/RABBITMQ-IP/rabbitmq.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service &>>${LOG_FILE}
    STAT_CHECK $? "Update SystemD Config file"

    # mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
    systemctl daemon-reload &>>${LOG_FILE} && systemctl restart ${component} &>>${LOG_FILE} && systemctl enable ${component} &>>${LOG_FILE}
    STAT_CHECK $? "Start ${component} Service"
}



DOWNLOAD(){
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
  STAT_CHECK $? "Download ${1} code"
  cd /tmp
  unzip -o /tmp/${1}.zip &>>${LOG_FILE}
  STAT_CHECK $? "Extract ${1} code"

 if [ ! -z "${component}" ]; then
   rm -rf /home/roboshop/${component} && mkdir -p /home/roboshop/${component} && cp -r /tmp/${component}-main/* /home/roboshop/${component} &>>${LOG_FILE}
       STAT_CHECK $? "Copy ${component} Contents"
 fi


}
APP_USER_SETUP(){

  id roboshop &>>${LOG_FILE}
    if [ $? -ne 0 ]; then
     useradd roboshop &>>${LOG_FILE}
     STAT_CHECK $? "Add Application User"
    fi
    DOWNLOAD ${component}
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

NODEJS(){
  component=${1}
   yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
  STAT_CHECK $? "Install Nodejs"

  APP_USER_SETUP


  cd /home/roboshop/${component} && npm install --unsafe-perm &>>${LOG_FILE}
  STAT_CHECK $? "Install Nodejs Dependencies"


 SYSTEMD_SETUP


}

LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}

set-hostname -skip-apply ${COMPONENT}

JAVA(){
  component=${1}
  yum install maven -y &>>${LOG_FILE}
  STAT_CHECK $? "Install Maven"

  APP_USER_SETUP

cd /home/roboshop/${component} && mvn clean package &>>${LOG_FILE} && mv target/${component}-1.0.jar ${component}.jar &>>${LOG_FILE}
STAT_CHECK $? "Compile the Java Code"

SYSTEMD_SETUP

}
PYTHON(){
  component=${1}
    yum install python36 gcc python3-devel -y &>>${LOG_FILE}
    STAT_CHECK $? "Install python3"

    APP_USER_SETUP

  cd /home/roboshop/${component} && pip3 install -r requirements.txt &>>${LOG_FILE}
  STAT_CHECK $? "Install python dependencies"

  SYSTEMD_SETUP

}
GOLANG(){
 component=${1}
     yum install golang -y &>>${LOG_FILE}
     STAT_CHECK $? "Install GOLANG"

     APP_USER_SETUP

   cd /home/roboshop/${component} && go mod init dispatch &>>${LOG_FILE} && go get &>>${LOG_FILE} && go build &>>${LOG_FILE}
   STAT_CHECK $? "Install Golang Dependencies & Compile"

   SYSTEMD_SETUP

}
