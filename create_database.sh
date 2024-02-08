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

# Check if the database name is present in the directory
check_database_exists() {
  local database_name="$1"
  local database_path="./Databases/$database_name"

  if [ -d "$database_path" ]; 
  then
    echo "--------------------------------------"
    echo "$database_name is already present, please enter a new name."
    echo "--------------------------------------"

    main
  fi
}

create_database() {
  local database_name="$1"

  mkdir "./Databases/$database_name"
  echo "-------------------------------------"
  echo "$database_name database is created successfully"
  echo "-------------------------------------"

  ./main.sh
}

# Get the database name and create it
main() {
  get_database_name
  check_valid_database "$database_name"
  check_database_exists "$database_name"
  create_database "$database_name"
}

main
