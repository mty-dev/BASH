#!/bin/bash

#ENTRY 
echo "#########################################"
echo "#       Services Start&Stop Creator     #"
echo "#########################################"

#QUESTION ABOUT SERVICES
echo "Enter name of services:"
echo "Remember about good sequence"
echo "EXAMPLE: apache2 mysqld network"
read -a services
sleep 1
echo "Name of services saved."
echo " "

#QUESTION ABOUT DIRECTORY TO CREATE SCRIPT FILES
echo "Enter directory to create script files:"
echo "EXAMPLE: /home/root"
read path
sleep 1
echo ""
echo "Path saved."
echo ""

fun_start ()
{
  echo "#!/bin/bash" > $path/services-start.sh
  
  for i in ${!services[@]}; 
    do
      echo "systemctl ${myArray[i]} start" > $path/services-start.sh
    done
}


fun_stop ()
{
  echo "#!/bin/bash" > $path/services-stop.sh
  
  for i in ${!services[@]}; 
    do
      echo "systemctl ${myArray[i]} stop" > $path/services-stop.sh
    done
}
