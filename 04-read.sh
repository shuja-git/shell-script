#!/bin/bash

#read -p "Enter user name" name
#useradd ${name}
#echo -e "\e[1;32m${name} user created successfully\e[0m"

# special variables

echo "script name- ${0} "
echo "First argument is- ${1}"
echo "Second argument is- ${2}"
echo "number of arguments being passed  ${#}"
echo "to read all the inputs passed- ${*}"
