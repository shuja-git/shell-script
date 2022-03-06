#!/bin/bash

source components/common.sh

# curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
#Install Mongo & Start Service.
# yum install -y mongodb-org
# systemctl enable mongod
# systemctl start mongod
#Update Liste IP address from 127.0.0.1 to 0.0.0.0 in config file
#Config file: /etc/mongod.conf

#then restart the service

# systemctl restart mongod
#Every Database needs the schema to be loaded for the application to work.
#Download the schema and load it.

# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js

#Symbol < will take the input from a file and give that input to the command.
#--------------------------------------------------------------------------

echo -e " ---------->>>>>>>>>>>>\e[1;35mMongoDB Setup\e[0m ------------<<<<<<<<  "

# curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
STAT_CHECK $? "Download MongoDB repo"



# yum install -y mongodb-org
yum install -y mongodb-org &>>${LOG_FILE}
STAT_CHECK $? "MongoDB Installation"

#Update Liste IP address from 127.0.0.1 to 0.0.0.0 in config file
#Config file: /etc/mongod.conf

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG_FILE}
STAT_CHECK $? "Update MongoDB Service"


# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
DOWNLOAD mongodb


# systemctl enable mongod
# systemctl start mongod
systemctl enable mongod &>>${LOG_FILE} && systemctl restart mongod &>>${LOG_FILE}
STAT_CHECK $? "Start MongoDB Service"

cd /tmp/mongodb-main

mongo < catalogue.js &>>${LOG_FILE} && mongo < users.js &>>${LOG_FILE}
STAT_CHECK $? "Load Schema"

#------------------------------------------
#               REDIS
echo -e " ---------->>>>>>>>>>>>\e[1;35mRedis Setup\e[0m ------------<<<<<<<<  "
#Install Redis.

 curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
STAT_CHECK $? "Download Redis Repo"
# yum install redis -y
yum install redis -y &>>${LOG_FILE}
STAT_CHECK $? "Install Redis"

#Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
STAT_CHECK $? "Update Redis config"

#Start Redis Database

systemctl enable redis &>>${LOG_FILE} && systemctl restart redis &>>${LOG_FILE}
STAT_CHECK $? "Update Redis"

echo -e " ---------->>>>>>>>>>>>\e[1;35mRabbitMQ Setup\e[0m<<<<<<<<<<<<------------"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
STAT_CHECK $? "Download RabbitMQ repo"

yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y rabbitmq-server -y &>>${LOG_FILE}
STAT_CHECK $? "Install Erlang and RabbitMQ "


systemctl enable rabbitmq-server &>>${LOG_FILE} &&  systemctl restart rabbitmq-server
STAT_CHECK $? "RabbitMQ Started"
#RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application.

#Create application user
rabbitmqctl list_users  | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
#  echo -e "\e[1;33mUser already exists"
#else
rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
STAT_CHECK $? "Create App user in RabbitMQ"
fi

rabbitmqctl set_user_tags roboshop administrator  &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${LOG_FILE}
STAT_CHECK $? "Configure App User Permissions"

#----------------------------------
echo -e " ---------->>>>>>>>>>>>\e[1;35mMySQL Setup\e[0m<<<<<<<<<<<<------------"

#As per the Application need, we are choosing MySQL 5.7 version.
#
#Setup MySQL Repo
## curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
#
#Install MySQL
## yum install mysql-community-server -y
#
#Start MySQL.
## systemctl enable mysqld
## systemctl start mysqld
#
#Now a default root password will be generated and given in the log file.
## grep temp /var/log/mysqld.log
#
#Next, We need to change the default root password in order to start using the database service.
## mysql_secure_installation
#
#You can check the new password working or not using the following command.
#
## mysql -u root -p
#
#Run the following SQL commands to remove the password policy.
#> uninstall plugin validate_password;

#-------------------------
#Setup MySQL Repo
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
STAT_CHECK $? "Download MySQL repo"

#Install MySQL
yum install mysql-community-server -y &>>${LOG_FILE}
STAT_CHECK $? "Installation MySQL"

systemctl enable mysqld &>>${LOG_FILE} && systemctl start mysqld &>>${LOG_FILE}
STAT_CHECK $? "Started MySQL"

DEFAULT_PASSWORD=$(sudo grep 'temporary password'  /var/log/mysqld.log | awk '{print $NF}')
echo ${DEFAULT_PASSWORD}


