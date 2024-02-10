#!/bin/bash

source database_functions.sh

main() {
  list_databases
  get_database_name
  check_valid_database $database_name
  check_database_presence_to_connect $database_name
  confirm_delete_database $database_name
  ./main.sh
}

main