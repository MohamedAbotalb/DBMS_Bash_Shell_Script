#!/bin/bash

source table_functions.sh

confirm_delete_table() {
  while true; 
  do
    read -p "Are you sure you want to delete $table_name table? (y/n): " choice
    case $choice in
      [Yy])
        delete_table
        break
        ;;
      [Nn])
        echo "---------------------------------------------"
        echo "Cancel delete!"
        echo "---------------------------------------------"
        break
        ;;
      *)
        echo "---------------------------------------------"
        echo "Please choose y/n"
        echo "---------------------------------------------"
        ;;
    esac
  done
}

delete_table() {
  rm "$database_dir/$table_name"
  rm "$database_dir/.metadata/$table_name.meta"
  rm "$database_dir/.metadata/$table_name.dtype"
  echo "---------------------------------------------"
  echo "Table $table_name is deleted successfully!"
  echo "---------------------------------------------"
}

drop_table() {
  list_available_tables
  get_table_name
  check_valid_table_name || drop_table
  check_table_exists || drop_table
  confirm_delete_table
  ./table_menu.sh $database_name
}

drop_table
