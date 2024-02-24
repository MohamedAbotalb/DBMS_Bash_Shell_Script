#!/bin/bash

# Source the database_functions.sh file to use the functions defined in it
source database_functions.sh

# Define the main function
main() {
  # List all databases
  list_databases

  # Get the database name from the user
  get_database_name

  # Check if the provided database name is valid
  check_valid_database

  # Check if the database exists and is ready to connect
  check_database_presence_to_connect

  # Confirm if the user wants to delete the database
  confirm_delete_database

  # Run the main script again
  ./main.sh
}

# Call the main function
main
