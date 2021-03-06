#!/bin/bash

#Install Maven, This will install Java too
# yum install maven -y
#As per the standard process, we always run the applications as a normal user.
#Create a user

# useradd roboshop
#Download the repo
#$ cd /home/roboshop
#$ curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
#$ unzip /tmp/shipping.zip
#$ mv shipping-main shipping
#$ cd shipping
#$ mvn clean package
#$ mv target/shipping-1.0.jar shipping.jar
#Update Servers IP address in /home/roboshop/shipping/systemd.service
#
#Copy the service file and start the service.

# mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
# systemctl daemon-reload
# systemctl start shipping
# systemctl enable shipping
#?----------------------
source components/common.sh
JAVA shipping