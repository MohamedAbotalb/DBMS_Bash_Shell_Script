#!/bin/bash

source database_functions.sh

create() {
  mkdir ./Databases/$database_name
  echo "-------------------------------------"
  echo "$database_name Database is created successfully"
  echo "-------------------------------------"
  ./main.sh
}

main() {
  list_databases
  get_database_name
  check_valid_database $database_name
  check_database_presence_to_create $database_name
  create
}

main
