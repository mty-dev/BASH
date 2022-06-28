#!/bin/bash

#ENTRY 
echo "#########################################"
echo "#       Services Start&Stop Creator     #"
echo "#########################################"

#QUESTION ABOUT SERVICES
echo "Enter name of services:"
echo "Remember about good sequence!"
echo "EXAMPLE: apache2 mysqld network"
read -a services
sleep 1
echo "Name of services saved."
echo " "

#QUESTION ABOUT DIRECTORY TO CREATE SCRIPT FILES
echo "Enter directory and name to script file:"
echo "EXAMPLE: /home/user/adminserver.sh"
echo "Remember about right file extension!"
read path
sleep 1
echo ""
echo "P"
echo ""

cat << EOF >> $path

#! /bin/bash

action='status'

while [ $# -gt 0 ]; do
  case "$1" in
    --status)
      action='status'
      ;;
    --stop)
      action='stop'
      ;;
    --start)
      action='start'
      ;;
    --restart)
      action='restart'
      ;;
    for i in ${!services[@]}; do
      --${myArray[$i]})
        ${myArray[$i]}="true"
        ;;        
    done
    --all)
      for i in ${!services[@]}; do
        ${myArray[$i]}="true"
        ;;
      done
    *)
      echo "Not known argument: ${1}" >&2
      exit 1
  esac
  shift
done
EOF
