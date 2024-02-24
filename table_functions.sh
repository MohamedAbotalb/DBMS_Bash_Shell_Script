#!/bin/bash

# Database directory
database_dir="./Databases/$database_name"

# Metadata directory
metadata_dir="$database_dir/.metadata"

# Array to store metadata and datatypes
metadata=()
pk_values=()

# Function to list available tables
list_available_tables() {
  if [[ $(ls $database_dir) ]]; 
  then
    echo "-------------------------------------"
    echo "--------- Available Tables ----------"
    ls $database_dir
    echo "-------------------------------------"
  else
    echo "-------------------------------------"
    echo "------ There is no table found ------"
    echo "-------------------------------------"

    ./table_menu.sh $database_name
  fi
}

# Function to get table name
get_table_name() {
  read -p "Enter the table name: " table_name
}

# Function to check if the table name is valid
check_valid_table_name() {
  local result=$(./check_valid_value.sh $table_name)

  if [[ $result ]]; 
  then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"

    return 1
  fi
}

# Function to check if the table exists
check_table_exists() {
  if [[ ! -f "$database_dir/$table_name" ]]; 
  then
    echo "-------------------------------------"
    echo "$table_name isn't present, please enter a new name"
    echo "-------------------------------------"
    return 1
  fi
}

# Function to create table meta path
create_table_meta_path() {
  table_name_path=$database_dir/$table_name
  table_meta_path=$metadata_dir/$table_name
}

# Function to get metadata and datatypes
get_metadata_and_datatypes() {
  metadata=($(awk -F: 'NR==1 {for(i=1;i<=NF;i++) print $i}' $table_meta_path.meta))
  datatypes=($(awk -F: 'NR==1 {for(i=1;i<=NF;i++) print $i}' $table_meta_path.dtype))
}

# Function to get primary key name
get_pk_name() {
  meta=$(awk 'NR==2 {print}' $table_meta_path.meta)
  pk=$(echo "$meta" | awk -F: '{print $2}')
}

# Function to get primary key index
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

# Function to get primary key values
get_pk_values() {
  pk_values=($(awk -F: "{print \$($index+1)}" "$table_name_path"))
}

# Function to get primary key datatype
get_pk_dtype() {
  dtype="${datatypes[$index]}"
}

# Function to check if the table is empty
check_data_presence() {
  if [[ ! -s $table_name_path ]]; 
  then
    echo "-------------------------------------"
    echo "-------- This table is empty --------"
    echo "-------------------------------------"

    ./table_menu.sh $database_name
  fi
}

# Function to get target row
get_target_row() {
  while IFS=: read -r -a fields; 
  do
    if [[ "${fields[$index]}" = "$PK" ]]; 
    then
      # Get the target row
      target_row=$(echo "${fields[*]}" | sed 's/ /:/g') # sed replaces space with :
      break
    fi
  done < $table_name_path
}
