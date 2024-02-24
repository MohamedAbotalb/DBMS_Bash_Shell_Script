#!/bin/bash

# Source the database_functions.sh file to use the functions defined in it
source database_functions.sh

# Define the connect function
connect() {
  # Change the directory to the specified database directory
  cd ./Databases/$database_name
  echo "-------------------------------------"
  # Change the directory back to the parent directory
  cd ../..
}

# Define the main function
main() {
  # List the available databases
  list_databases
  # Get the name of the database to connect to
  get_database_name
  # Check if the selected database is valid
  check_valid_database
  # Check if the selected database is present to connect to
  check_database_presence_to_connect
  # Connect to the selected database
  connect
  # Run the table_menu.sh script with the selected database name as an argument
  ./table_menu.sh $database_name
}

# Call the main function to start the script
main
