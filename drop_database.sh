#!/bin/bash

echo "-------------------------------------"
echo "Available Databases:"
ls ./Databases
echo "-------------------------------------"

read -p "Enter name of database: " database_name

result=`./check_valid_value.sh $database_name`

database_path="./Databases/$database_name"

# check if database name is not valid
if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"

  ./drop_database.sh

# Check if the database name doesn't match anyone in the databases
elif [ ! -d "$database_path" ]; 
then
  echo "--------------------------------------"
  echo "Database $database_name doesn't exist!"
  echo "--------------------------------------"

  ./drop_database.sh

else
	while true;
	do
		read -p "Are you Sure You Want To delete $database_name Database? y/n " choice

		case $choice in

			[Yy] ) 
				rm -r "$database_path"
				echo "---------------------------------------------"
				echo "Database $database_name deleted successfully!"
				echo "---------------------------------------------"
				break
				;;

			[Nn] )
				echo "----------------------"
				echo "Cancel delete!"
				echo "----------------------"
				break
				;;

			* ) 
				echo "--------------------------"
				echo "Please choose y/n"
				echo "--------------------------"
				;;
		esac
	done

  ./main.sh

fi
