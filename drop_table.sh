#!/bin/bash

# Source the table functions script
source table_functions.sh

# Function to confirm table deletion
confirm_delete_table() {
  # While loop to keep asking for confirmation until the user provides a valid response
  while true; 
  do
    # Prompt the user for their choice
    read -p "Are you sure you want to delete $table_name table? (y/n): " choice
    # Case statement to handle the user's choice
    case $choice in
      # If the user chooses 'y' or 'Y', delete the table
      [Yy])
        delete_table
        break
        ;;
      # If the user chooses 'n' or 'N', cancel the deletion
      [Nn])
        echo "---------------------------------------------"
        echo "Cancel delete!"
        echo "---------------------------------------------"
        break
        ;;
      # If the user provides any other input, prompt them to choose 'y' or 'n'
      *)
        echo "---------------------------------------------"
        echo "Please choose y/n"
        echo "---------------------------------------------"
        ;;
    esac
  done
}

# Function to delete the table
delete_table() {
  # Remove the table file
  rm "$database_dir/$table_name"
  # Remove the table metadata file
  rm "$database_dir/.metadata/$table_name.meta"
  # Remove the table data type file
  rm "$database_dir/.metadata/$table_name.dtype"
  # Display a message indicating the table deletion was successful
  echo "---------------------------------------------"
  echo "Table $table_name is deleted successfully!"
  echo "---------------------------------------------"
}

# Function to drop the table
drop_table() {
  # List the available tables
  list_available_tables
  # Get the table name
  get_table_name
  # Check if the table name is valid, if not, drop the table
  check_valid_table_name || drop_table
  # Check if the table exists, if not, drop the table
  check_table_exists || drop_table
  # Confirm the table deletion
  confirm_delete_table
  # Run the table menu script with the database name as an argument
  ./table_menu.sh $database_name
}

# Call the drop_table function
drop_table
