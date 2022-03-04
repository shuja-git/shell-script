LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}

STAT_CHECK(){
  if [ "${1}" -ne 0 ]; then
    echo -e "\e[1;31m${2} - Failed\e[0m"
    exit 1
  else
    echo -e "\e[1;32m${2} - Success\e[0m"
  fi
}

set-hostname -skip-apply ${COMPONENT}

DOWNLOAD (){
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip"
  STAT_CHECK $? "Download ${1} code"
}





