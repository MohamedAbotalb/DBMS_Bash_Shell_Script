#!/bin/bash

# Function to get the name of the database
get_database_name() {
  # Prompt the user to enter the name of the database
  read -p "Enter name of database: " database_name
}

# Function to check if the entered database name is valid
check_valid_database() {
  # Call the check_valid_value.sh script with the database name as an argument
  local result=$(./check_valid_value.sh $database_name)

  # If the result is not empty (i.e., the database name is valid)
  if [[ $result ]]; 
  then
    echo "-------------------------------------"
    # Print the result (which is an error message)
    echo "$result"
    echo "-------------------------------------"
    
    # Call the main function
    main
  fi
}

# Function to check if the database already exists
check_database_presence_to_create() {
  # Set the path to the database directory
  local database_dir=./Databases/$database_name

  # If the database directory exists
  if [[ -d "$database_dir" ]]; 
  then
    echo "--------------------------------------"
    echo "$database_name is already present, please enter a new name"
    echo "--------------------------------------"
    
    # Call the main function
    main
  fi
}

# Function to check if the database exists before connecting to it
check_database_presence_to_connect() {
  # Set the path to the database directory
  local database_dir=./Databases/$database_name

  # If the database directory does not exist
  if [[ ! -d "$database_dir" ]]; 
  then
    echo "--------------------------------------"
    echo "Database $database_name doesn't exist!"
    echo "--------------------------------------"
    
    # Call the main function
    main
  fi
}

# Function to list all available databases
list_databases() {
  # If there are any directories in the Databases directory
  if [[ $(ls Databases) ]]; 
  then
    echo "-------------------------------------"
    echo "-------- Available Databases --------"
    # List all the directories in the Databases directory
    ls Databases
    echo "-------------------------------------"
    
  else
    echo "-------------------------------------"
    echo "---- There is no Database found -----"
    echo "-------------------------------------"
  fi
}

# Function to confirm deletion of a database
confirm_delete_database() {
  # Set the path to the database directory
  local database_dir=./Databases/$database_name
  
  # While the user has not made a decision
  while true; 
  do
    # Prompt the user to confirm deletion
    read -p "Are you Sure You Want To delete $database_name Database? y/n " choice
    # If the user chose 'y'
    case $choice in
      [Yy] )
        # Delete the database directory
        rm -r $database_dir
        echo "-------------------------------------"
        echo "Database $database_name is deleted successfully!"
        echo "-------------------------------------"
        break
        ;;
        # If the user chose 'n'
      [Nn] )
        echo "-------------------------------------"
        echo "Cancel delete!"
        echo "-------------------------------------"
        # Break out of the loop
        break
        ;;
        # If the user chose something else
      * )
        echo "-------------------------------------"
        echo "Please choose y/n"
        echo "-------------------------------------"
        ;;
    esac
  done
}
