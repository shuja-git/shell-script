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
DOWN_REPO() {
curl -L https://raw.githubusercontent.com/roboshop-devops-project/${1}/main/${1}.repo -o /etc/yum.repos.d/${1}.repo &>>${LOG_FILE}
STAT_CHECK $? "Download ${1} repo"
}




