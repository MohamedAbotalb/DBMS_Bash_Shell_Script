#!/bin/bash

database_name=$1

echo "-------------------------------------"
echo "WELCOME TO $database_name Database:"
echo "-------------------------------------"

PS3="Choose what you want: "
select choice in "Create Table" "List Tables" "Select from Table" "Insert into Table" "Update Record" "Delete Record" "Drop Table" "Return to main menu"
do
  case $REPLY in
  # Create New Table 
  1) ./create_table.sh $database_name
  ;; 

  # list Tables 
  2) ./list_tables.sh $database_name
  ;;

  # Select from Table
  3) ./select_from_table.sh $database_name
  ;;

  # Insert into Table
  4) ./insert_into_table.sh $database_name
  ;;

  # Update Record
  5) ./update_record.sh $database_name
  ;;

  # Delete from table
  6) ./delete_record.sh $database_name
  ;;

  # Drop Table
  7) ./drop_table.sh $database_name
  ;;

  # Return to main menu
  8) ./main.sh 
  ;;
      
  *) echo "$REPLY is not one of the choices" ;;
  
  esac
done