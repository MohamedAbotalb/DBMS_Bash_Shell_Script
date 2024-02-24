#!/bin/bash

# Source the database_functions.sh file to use the functions defined in it
source database_functions.sh

# Function to create a new database
create() {
  # Create a new directory for the database
  mkdir ./Databases/$database_name
  
  # Print a message indicating that the database was created successfully
  echo "-------------------------------------"
  echo "$database_name Database is created successfully"
  echo "-------------------------------------"
}

# Function to run the main program
main() {
  # List all the databases
  list_databases
  
  # Get the name of the database to create
  get_database_name
  
  # Check if the database name is valid
  check_valid_database
  
  # Check if the database already exists
  check_database_presence_to_create
  
  # Create the database
  create
  
  # Run the main script again
  ./main.sh
}

# Run the main function
main
