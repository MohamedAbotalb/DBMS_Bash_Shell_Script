#!/bin/bash

echo "-------------------------------------"
echo "WELCOME TO BASH SCRIPT DBMS:"
echo "-------------------------------------"

PS3="Choose what you want: "
select choice in "Create Database" "List Databases" "Connect to a Database" "Drop a Database" "Quit"
do
  case $REPLY in
  # Create New Database 
  1) ./create_database.sh 
  ;; 

  # list Databases 
  2) ./list_databases.sh 
  ;;

  # Connect to a Database
  3) ./connect_to_database.sh 
  ;;

  # Drop an existing Database
  4) ./drop_database.sh ;;

  5) exit 
  ;;
      
  *) echo "$REPLY is not one of the choices" ;;
  
  esac
done