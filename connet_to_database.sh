##!/bin/bash
 read -p "Please enter database name " $database_name

result=`./check_valid_value.sh $database_name`

if [[ $result ]]

  then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"
  
  ./connet_to_database.sh

# Check if the database_name is present in the Directory
elif [[ -d ./Databases/$database_name ]];
  then
    echo "-------------------------------------"
    echo cd ./Databases/$database_name 
    echo "-------------------------------------"

    ./table_menu.sh

  else
    echo "----------------------------------"

       