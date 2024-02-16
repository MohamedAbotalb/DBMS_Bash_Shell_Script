#!/bin/bash

source database_functions.sh

main() {
  list_databases
  get_database_name
  check_valid_database
  check_database_presence_to_connect
  confirm_delete_database 
  ./main.sh
}

main