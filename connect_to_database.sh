#!/bin/bash

get_database_name() {
  read -p "Enter name of database: " database_name
}

check_valid_database() {
  local database_name="$1"
  local result=$(./check_valid_value.sh "$database_name")

  if [[ $result ]]; 
	then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"

    main
  fi
}

check_database_exists() {
  local database_name="$1"
  local database_path="./Databases/$database_name"

  if [ ! -d "$database_path" ]; 
  then
    echo "--------------------------------------"
    echo "Database $database_name doesn't exist!"
    echo "--------------------------------------"

    main
  fi
}

connect_to_database() {
  local database_name="$1"

  cd "./Databases/$database_name"
  echo "-------------------------------------"
  cd ../..
  
  ./table_menu.sh "$database_name"
}

# Get the database name and connect to it
main() {
  get_database_name
  check_valid_database "$database_name"
  check_database_exists "$database_name"
  connect_to_database "$database_name"
}

main

