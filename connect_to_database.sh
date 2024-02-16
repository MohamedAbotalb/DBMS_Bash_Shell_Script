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
  check_valid_database
  check_database_presence_to_connect
  connect
  ./table_menu.sh $database_name
}

main
