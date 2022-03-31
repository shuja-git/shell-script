#!/bin/bash

# check whether script is running as root user or not
USER_ID=$(id -u)
if [ "${USER_ID}" -ne 0 ]; then
  echo -e "\e[1;31mYou should be root user to run this script\e[0m"
  exit
fi

# check input is provided or not
#export  COMPONENT=${1}
COMPONENT=${1}
if [ -z "${COMPONENT}" ]; then
  echo -e "\e[1;31mComponent Input is Missing\e[0m"
  exit
fi

# check component script is there or not
if [ ! -e  components/"${COMPONENT}".sh ]; then
  echo -e "\e[1;31mGiven Component does not exists\e[0m"
  exit
fi
# if component script is there
bash components/"${COMPONENT}".sh

