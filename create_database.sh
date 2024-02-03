#!/bin/bash

read -p "Enter the name of Database: " database_name

result=`./check_valid_value.sh $database_name`

if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"
  ./create_database.sh

# Check if the database_name is present in the Directory
elif [[ -d ./Databases/$database_name ]];
then
  echo "-------------------------------------"
  echo "$database_name is present, please enter a new name"
  echo "-------------------------------------"
  ./create_database.sh

else
  mkdir ./Databases/$database_name
  echo "-------------------------------------"
  echo "$database_name database is created successfully"
  echo "-------------------------------------"
  ./main.sh

fi
