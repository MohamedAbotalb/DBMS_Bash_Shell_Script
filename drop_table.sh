#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name

list_available_tables() {
  if [[ $(ls "$database_dir") ]]; then
    echo "-------------------------------------"
    echo "--------- Available Tables ----------"
    ls "$database_dir"
    echo "-------------------------------------"
  else
    echo "-------------------------------------"
    echo "There are no tables found"
    echo "-------------------------------------"
    ./table_menu.sh "$database_name"
  fi
}

get_table_name() {
  read -p "Enter the table name: " table_name
}

check_valid_table_name() {
  local result=$(./check_valid_value.sh "$table_name")

  if [[ $result ]]; 
  then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"

    drop_table
  fi
}

check_table_exists() {
  if [[ ! -f "$database_dir/$table_name" ]]; 
  then
    echo "-------------------------------------"
    echo "$table_name isn't present, please enter a new name"
    echo "-------------------------------------"

    drop_table
  fi
}

confirm_delete_table() {
  while true; 
  do
    read -p "Are you sure you want to delete $table_name? (y/n): " choice
    case $choice in
      [Yy])
        delete_table
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
  read_table_name
  check_valid_table_name
  check_table_exists
  confirm_delete_table
  ./table_menu.sh "$database_name"
}

drop_table
