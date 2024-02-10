#!/bin/bash

database_name=$1
database_dir="./Databases/$database_name"
metadata_dir="$database_dir/.metadata"

list_available_tables() {
  if [[ $(ls $database_dir) ]]; 
  then
    echo "-------------------------------------"
    echo "--------- Available Tables ----------"
    ls $database_dir
    echo "-------------------------------------"

  else
    echo "-------------------------------------"
    echo "There are no tables found"
    echo "-------------------------------------"

    ./table_menu.sh $database_name
  fi
}

get_table_name() {
  read -p "Enter the table name: " table_name
}

check_valid_table_name() {
  local result=$(./check_valid_value.sh "$table_name")

  if [[ $result ]]; then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"

    select_from_table
  fi
}

check_table_exists() {
  if [[ ! -f "$database_dir/$table_name" ]]; 
  then
    echo "-------------------------------------"
    echo "$table_name isn't present, please enter a new name"
    echo "-------------------------------------"

    select_from_table
  fi
}

create_table_meta_path() {
  table_name_path=$database_dir/$table_name
  table_meta_path=$metadata_dir/$table_name
}

check_data_presence() {
  if [[ ! -s "$table_name_path" ]]; 
  then
    echo "-------------------------------------"
    echo "This table is empty."
    echo "-------------------------------------"

    ./table_menu.sh $database_name
  fi
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

select_all_rows() {
  echo "-------------------------------------"
  head -1 $table_meta_path.meta
  echo "-------------------------------------"
  cat $table_name_path
  echo "-------------------------------------"

  ./table_menu.sh $database_name
}

select_specific_row() {
  get_pk_name
  get_pk_index
  get_pk_dtype

  while true; 
  do
    read -p "Enter the value of the primary key [$pk]: " PK

    if [[ $dtype = "int" && "$PK" = +([0-9]) || $dtype = "string" && "$PK" = +([a-zA-Z@.]) ]]; 
    then
      get_pk_values

      local flag=0
      for val in "${pk_values[@]}"; 
      do
        if [[ "$PK" = "$val" ]]; 
        then
          flag=1
          break
        fi
      done

      if [[ $flag = 0 ]]; 
      then
        echo "-------------------------------------"
        echo "The value of $pk isn't present in the table, enter a new value"
        echo "-------------------------------------"

      # The PK value is found
      else
        while IFS=: read -r -a fields; 
        do
          if [[ "${fields[$index]}" = "$PK" ]]; 
          then
            echo "-------------------------------------"
            head -1 $table_meta_path.meta
            echo "-------------------------------------" 
            echo "${fields[*]}" | sed 's/ /:/g' # sed replaces space with :
            echo "-------------------------------------"
            break 2
          fi
        done < "$table_name_path"
      fi
    else
      echo "-------------------------------------"
      echo "The value of $pk is invalid, enter a new value"
      echo "-------------------------------------"
    fi
  done

  ./table_menu.sh $database_name
}

select_from_table() {
  list_available_tables
  get_table_name
  check_valid_table_name
  check_table_exists
  create_table_meta_path
  check_data_presence
  get_metadata_and_datatypes
}

select_from_table

PS3="Choose what you want: "
select choice in "Select All" "Select Specific Row"; 
do
  case $REPLY in

  # Select all rows
  1)
    select_all_rows
    ;;

  # Select specific row
  2)
    select_specific_row
    ;;

  *)
    echo "$REPLY is not one of the choices"
    ;;
  esac
done
