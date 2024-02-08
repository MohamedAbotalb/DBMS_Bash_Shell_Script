#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name

			read -p "Enter the name of table you want to delete from: " table_name
			until [[ -f ./Databases/$1/$table_name ]]
                        do
                                read -p "Record does't Exist, Re-Enter the Table you want to delete from: " table_name
                        done

		 	 read -p "Enter Record Primary Key: " pk
			 pk=$(cut -f 1 -d: ./Databases/$1/$table_name | grep -w ^$pk)
			 until [[ $pk ]] 
                      	 do
                    		  echo "This Primary Key doesn't Exist" 
                                  read -p "Enter another Value for PK: " pk
                                  pk=$(cut -f 1 -d":" ./Databases/$1/$table_name | grep -w ^$pk)
                         done
			sed -i  "/^$pk/d"   ./Databases/$1/$table_name
			echo "Record was Deleted Successfully"
