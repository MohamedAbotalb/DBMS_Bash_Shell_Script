#!/bin/bash

# Source the table functions file
source table_functions.sh

# Function to insert data into a table
insert_data() {
  # Get the length of the metadata array
  local length=${#metadata[@]};

  # Initialize an empty array to store the real data
  local real_data=();

  # Loop through each column in the metadata array
  for((i=0; i < $length; i++))
  do
    # Get the name and type of the current column
    local name="${metadata[$i]}";
    local type="${datatypes[$i]}";

    # Loop until the user provides a valid input for the current column
    while true
    do
      # Check if the column is the primary key or not
      if [[ "$name" = "$pk" ]]; then
        read -p "Enter the value of Primary Key [$name]: " value;
      else
        read -p "Enter the value of [$name]: " value;
      fi

      # Check if the provided input is valid for the current column
      if [[ $type = "int" && "$value" = +([0-9]) || $type = "string" && "$value" = +([a-zA-Z@.]) ]];
      then
        # Check for duplicate primary key value
        flag=0;
        for val in "${pk_values[@]}";
        do
          if [[ "$val" = "$value" ]]; then
            flag=1;
            echo "-------------------------------------";
            echo "This value of Primary Key is present before, please enter a new $name value";
            echo "-------------------------------------";
            break;
          fi
        done

        # If the provided input is valid and not a duplicate primary key value, add it to the real_data array and break the loop
        if [[ "$flag" = "0" ]];
        then
          real_data+=("$value");
          break;
        fi
      else
        echo "-------------------------------------";
        echo "Invalid input, please enter a valid $name value";
        echo "-------------------------------------";
      fi
    done
  done

  # Insert the data into the table
  for ((i = 0; i < $length; i++))
  do
    # If the current column is not the last one, append the value to the line
    if [[ $i != $(($length - 1)) ]];
    then
      echo -n "${real_data[$i]}:" >> "$table_name_path";
    else
      # If the current column is the last one, append the value to a new line
      echo "${real_data[$i]}" >> "$table_name_path";
    fi
  done

  echo "-------------------------------------";
  echo "Data is Inserted Successfully";
  echo "-------------------------------------";

  # Call the table menu script with the database name as an argument
  ./table_menu.sh "$database_name";
}

# Function to insert data into a table
insert_into_table() {
  # List the available tables
  list_available_tables;

  # Get the table name
  get_table_name;

  # Check if the table name is valid
  check_valid_table_name || insert_into_table;

  # Check if the table exists
  check_table_exists || insert_into_table;

  # Create the table metadata path
  create_table_meta_path;

  # Get the metadata and datatypes arrays
  get_metadata_and_datatypes;

  # Get the primary key name
  get_pk_name;

  # Get the primary key index
  get_pk_index;

  # Get the primary key values
  get_pk_values;

  # Insert the data into the table
  insert_data;
}

# Call the insert_into_table function
insert_into_table;
