#!/bin/bash

# Source table_functions.sh to use its functions
source table_functions.sh

# Function to delete a row from a table
delete_row() {
  # Get the target row
  get_target_row
  
  # Loop until the user confirms or cancels the deletion
  while true; 
  do
    # Prompt the user to confirm or cancel the deletion
    read -p "Are you sure you want to delete this row? (y/n): " choice
    case $choice in
      # If the user confirms the deletion
      [Yy] ) 
          # Delete the row from the table
          sed -i "/$target_row/d" $table_name_path
          # Print a success message
          echo "---------------------------------------------"
          echo "Row in $table_name table deleted successfully!"
          echo "---------------------------------------------"
          # Break the loop to exit the function
          break
          ;;
      # If the user cancels the deletion
      [Nn] )
          # Print a cancel message
          echo "----------------------"
          echo "Cancel delete!"
          echo "----------------------"
          # Break the loop to exit the function
          break
          ;;
      # If the user enters an invalid choice
      * ) 
          # Print an error message
          echo "--------------------------"
          echo "Please choose y/n"
          echo "--------------------------"
          ;;
    esac
  done
}

# Function to delete a record from a table
delete_record() {
  list_available_tables
  get_table_name
  check_valid_table_name || delete_record 
  check_table_exists || delete_record
  create_table_meta_path
  check_data_presence
  get_metadata_and_datatypes
  get_pk_name
  get_pk_index
  get_pk_values
  get_pk_dtype

  # Loop until the user enters a valid primary key value
  while true; 
  do
    # Prompt the user to enter the primary key value
    read -p "Enter the value of the primary key [$pk] to select a row: " PK

    # If the user enters a valid primary key value
    if [[ $dtype = "int" && "$PK" = +([0-9]) || $dtype = "string" && "$PK" = +([a-zA-Z@.]) ]]; 
    then
      # Flag to check if the primary key value exists in the table
      flag=0
      # Loop through the primary key values
      for val in "${pk_values[@]}"; 
      do
        # If the user-entered primary key value matches an existing value
        if [[ "$PK" = "$val" ]]; 
        then
          flag=1
          break
        fi
      done

      # If the primary key value exists in the table
      if [[ $flag = 0 ]]; 
      then
        # Print an error message
        echo "-------------------------------------"
        echo "The value of $pk isn't present in the table, enter a new value"
        echo "-------------------------------------"
      # If the primary key value is valid
      else
        delete_row
        break
      fi
    # If the user enters an invalid primary key value
    else
      # Print an error message
      echo "-------------------------------------"
      echo "The value of $pk is invalid, enter a new value"
      echo "-------------------------------------"
    fi
  done

  # Call the table_menu.sh script with the database name as an argument
  ./table_menu.sh $database_name
}

delete_record
