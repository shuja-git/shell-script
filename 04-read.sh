#!/bin/bash

read -p "Enter user name" name
useradd ${name}
echo -e "\e[1;32m${name} user created successfully\e[0m"
