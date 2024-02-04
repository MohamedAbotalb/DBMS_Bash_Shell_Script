#!/bin/bash
echo -e "Enter a database name to delete: \c"
read database_name
database_path="./DataBases/$database_name"

if [ ! -d "$database_path" ]; 
then
  echo "==================================="
  echo "Database $database_name doesn't exist!"

  echo "==================================="

    ./main.sh

else
  
  echo -e "Are you Sure You Want To delete $database_name Database? y/n \c"
  read choice;
	case $choice in
		 [Yy]* ) 
			rm -r "$database_path"
			echo "============================================"
         		echo "Database $database_name deleted successfully!"
         		echo "============================================"
			;;
		 [Nn]* )
      			echo "======================"
			echo "Cancel delete!"
      			echo "======================"
			;;
		 * ) 
		 	echo "===================="
			echo "Please choose y/n"
			echo "===================="
			;;
	esac
  
    ./main.sh

fi