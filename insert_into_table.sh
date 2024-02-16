#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name
metadata_dir=$database_dir/.metadata

list_available_tables() {
  if [[ $(ls "$database_dir") ]]; 
  then
    echo "-------------------------------------"
    echo "--------- Available Tables ----------"
    ls "$database_dir"
    echo "-------------------------------------"

  else
    echo "-------------------------------------"
    echo "There are no tables found"
    echo "-------------------------------------"

    ./table_menu.sh "$database_name"
  fi
}

get_table_name() {
  read -p "Enter the table name: " table_name
}

check_valid_table_name() {
  local result=$(./check_valid_value.sh $table_name)

  if [[ $result ]]; 
  then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"

    insert_into_table
  fi
}

check_table_exists() {
  if [[ ! -f "$database_dir/$table_name" ]]; 
  then
    echo "-------------------------------------"
    echo "$table_name isn't present, please enter a new name"
    echo "-------------------------------------"

    insert_into_table
  fi
}

create_table_meta_path() {
  table_name_path=$database_dir/$table_name
  table_meta_path=$metadata_dir/$table_name
}

# Create an array to get the columns names and datatypes from meta and dtype files
get_metadata_and_datatypes() {
  metadata=($(awk -F: 'NR==1 {for(i=1;i<=NF;i++) print $i}' $table_meta_path.meta))
  datatypes=($(awk -F: 'NR==1 {for(i=1;i<=NF;i++) print $i}' $table_meta_path.dtype))
}

# Get the primary key value from the metadata file
get_pk_name() {
  meta=$(awk 'NR==2 {print}' $table_meta_path.meta)
  pk=$(echo "$meta" | awk -F: '{print $2}')
}

# Read the second line and get the index of the primary key
get_pk_index() {
  index=""
  for ((i=0; i < ${#metadata[@]}; i++)); 
  do
    if [[ "$pk" = "${metadata[$i]}" ]]; 
    then
      index=$i
      break
    fi
  done
}

# Get the primary key values to check if the entered value is present or not
get_pk_values() {
  pk_values=($(awk -F: "{print \$($index+1)}" "$table_name_path"))
}

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
  check_valid_table_name
  check_table_exists
  create_table_meta_path
  get_metadata_and_datatypes
  get_pk_name
  get_pk_index
  get_pk_values
  insert_data
}

insert_into_table
