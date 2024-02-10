#!/bin/bash

source database_functions.sh

connect() {
  cd ./Databases/$database_name
  echo "-------------------------------------"
  cd ../..
}

main() {
  list_databases
  get_database_name
  check_valid_database $database_name
  check_database_presence_to_connect $database_name
  connect
  ./table_menu.sh $database_name
}

main
