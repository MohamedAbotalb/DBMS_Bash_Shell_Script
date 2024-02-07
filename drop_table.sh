#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name

echo "-------------------------------------"
echo "Available Tables in $database_name:"
ls $database_dir
echo "-------------------------------------"

# Ask the user for the table name
read -p "Enter the name of the table to delete: " table_name

result=`./check_valid_value.sh $table_name`

# check if the table name is not valid
if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"

  ./drop_table.sh $database_name

# Check if the table name isn't present in the selected database
elif [[ ! -f $database_dir/$table_name ]];
then
  echo "-------------------------------------"
  echo "$table_name isn't present, please enter a new name"
  echo "-------------------------------------"

  ./drop_table.sh $database_name

else
  # Check if the file exists

  read -p "Are you sure you want to delete $table_name? (y/n): " choice

  case $choice in

  [Yy] ) 
      rm "$database_dir/$table_name"
      rm "$database_dir/.metadata/$table_name.meta"
      rm "$database_dir/.metadata/$table_name.dtype"
      echo "---------------------------------------------"
      echo "Table $table_name deleted successfully!"
      echo "---------------------------------------------"
      ;;

  [Nn] )
      echo "----------------------"
      echo "Cancel delete!"
      echo "----------------------"
      ;;

  * ) 
      echo "--------------------------"
      echo "Please choose y/n"
      echo "--------------------------"
      ;;
  esac
  
  ./table_menu.sh $database_name
fi