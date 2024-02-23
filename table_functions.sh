#!/bin/bash

# Global Variables
database_name=$1
database_dir=./Databases/$database_name
metadata_dir=$database_dir/.metadata
metadata=()
pk_values=()

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

    return 1
  fi
}

check_table_exists() {
  if [[ ! -f "$database_dir/$table_name" ]]; 
  then
    echo "-------------------------------------"
    echo "$table_name isn't present, please enter a new name"
    echo "-------------------------------------"
    return 1
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

# Get the datatype value for the PK
get_pk_dtype() {
  dtype="${datatypes[$index]}"
}

check_data_presence() {
  if [[ ! -s $table_name_path ]]; 
  then
    echo "-------------------------------------"
    echo "-------- This table is empty --------"
    echo "-------------------------------------"

    ./table_menu.sh $database_name
  fi
}

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
