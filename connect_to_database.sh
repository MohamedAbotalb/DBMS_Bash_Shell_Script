#!/bin/bash

read -p "Please enter database name: " database_name

result=`./check_valid_value.sh $database_name`

if [[ $result ]]
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"
  
  ./connect_to_database.sh

# Check if the database_name is not present in the Directory
elif [[ ! -d ./Databases/$database_name ]];
then
  echo "-------------------------------------"
  echo "$database_name is not present, please enter a new name"
  echo "-------------------------------------"

  ./connect_to_database.sh

else
  cd ./Databases/$database_name 
  echo "-------------------------------------"
  cd ../..
  
  ./table_menu.sh $database_name

fi 
