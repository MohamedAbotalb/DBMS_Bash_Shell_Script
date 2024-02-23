#!/bin/bash

source table_functions.sh

insert_data() {
  local length=${#metadata[@]}

  # Ask the user to insert the data for each column
  local real_data=()
  for((i=0; i < $length; i++)) 
  do
    local name="${metadata[$i]}"
    local type="${datatypes[$i]}"

    while true; 
    do
      # check if the column is the primary key or not
      if [[ "$name" = "$pk" ]]; then
        read -p "Enter the value of Primary Key [$name]: " value
      else
        read -p "Enter the value of [$name]: " value
      fi

      if [[ $type = "int" && "$value" = +([0-9]) || $type = "string" && "$value" = +([a-zA-Z@.]) ]]; 
      then
        # Check for duplicate primary key value
        flag=0
        for val in "${pk_values[@]}"; 
        do
          if [[ "$val" = "$value" ]]; then
            flag=1
            echo "-------------------------------------"
            echo "This value of Primary Key is present before, please enter a new $name value"
            echo "-------------------------------------"
            break 
          fi
        done

        if [[ "$flag" = "0" ]]; 
        then
          real_data+=("$value")
          break  
        fi
      else
        echo "-------------------------------------"
        echo "Invalid input, please enter a valid $name value"
        echo "-------------------------------------"
      fi
    done
  done

  # Insert data into the table
  for ((i = 0; i < $length; i++)); 
  do
    if [[ $i != $(($length - 1)) ]]; 
    then
      echo -n "${real_data[$i]}:" >> "$table_name_path"
    else
      echo "${real_data[$i]}" >> "$table_name_path"
    fi
  done

  echo "-------------------------------------"
  echo "Data is Inserted Successfully"
  echo "-------------------------------------"

  ./table_menu.sh "$database_name"
}

insert_into_table() {
  list_available_tables
  get_table_name
  check_valid_table_name || insert_into_table
  check_table_exists || insert_into_table
  create_table_meta_path
  get_metadata_and_datatypes
  get_pk_name
  get_pk_index
  get_pk_values
  insert_data
}

insert_into_table
