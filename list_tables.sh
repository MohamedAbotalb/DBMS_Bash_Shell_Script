#!/bin/bash

database_name=$1
database_dir="./Databases/$database_name"

# Check if there is a table in the Database direcotry or not
if [[ $(ls $database_dir) ]];
then
  echo "-------------------------------------"
  echo "Available tables in $database_name:"
  ls $database_dir
  echo "-------------------------------------" 

else
  echo "-------------------------------------"
  echo "There is no tables found"
  echo "-------------------------------------"
  
fi

./table_menu.sh $database_name