#!/bin/bash

# Global Variables
database_name=$1
database_dir="./Databases/$database_name"
metadata_dir="$database_dir/.metadata"
metadata=()

list_available_tables() {
  if [[ $(ls "$database_dir") ]]; 
  then
    echo "-------------------------------------"
    echo "--------- Available Tables ----------"
    ls "$database_dir"
    echo "-------------------------------------"
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
    create_table "$database_name"
  fi
}

check_table_exists() {
  if [[ -f "$database_dir/$table_name" ]]; 
  then
    echo "-------------------------------------"
    echo "$table_name is present, please enter a new name"
    echo "-------------------------------------"
    create_table "$database_name"
  fi
}

create_metadata_dir() {
  if [[ ! -d $metadata_dir ]] 
  then
    mkdir -p $metadata_dir
  fi
}

create_table_meta_path() {
  table_name_path=$database_dir/$table_name
  table_meta_path=$metadata_dir/$table_name
}

create_table_columns() {
  create_metadata_dir

  # check if the columns number is a positive decimal only
  while true; 
  do
    read -p "Enter the number of columns: " columns

    if [[ $columns =~ ^[1-9][0-9]*$ ]]; 
    then
      break    
    else
      echo "-------------------------------------"
      echo "Invalid columns number"
      echo "-------------------------------------"
    fi
  done

  # Get the name of each column and check its value is valid or not and contains at least 2 characters
  for ((i=1; i <= columns; i++)); 
  do
    while true;
    do
      flag=0
      read -p "Enter the name of column $i: " name
  
      if [[ $name =~ ^[a-zA-Z]{2,}[a-zA-Z_]*$ || $name =~ *" "* ]]
      then
        # Check if the column name is present before in the table or not
        for meta in "${metadata[@]}";
        do
          if [[ "$name" = "$meta" ]];
          then
            flag=1
            break
          fi
        done

        if [[ $flag = 0 ]];
        then
          metadata+=("$name")
          break
        else
          echo "-------------------------------------"
          echo "$name column is present before in the table, enter a new column name"
          echo "-------------------------------------"
        fi
      else
        echo "-------------------------------------"
        echo "Invalid column name"
        echo "-------------------------------------"
      fi
    done

    # check if the datatype isn't string or integer 
    while true; 
    do
      read -p "Enter the datatype of column $i [string/int]: " datatype

      if [[ "$datatype" != int && "$datatype" != string ]]; 
      then
        echo "-------------------------------------"
        echo "Invalid datatype"
        echo "-------------------------------------"
      else
        break
      fi
    done

    if [[ i -eq $columns ]]; 
    then
      echo "$name" >> "$table_meta_path.meta"
      echo "$datatype" >> "$table_meta_path.dtype"
    else
      echo -n "$name:" >> "$table_meta_path.meta"
      echo -n "$datatype:" >> "$table_meta_path.dtype"
    fi
  done

  set_primary_key "$table_name"

  touch $table_name_path
  echo "-------------------------------------"
  echo "$table_name table is created successfully"
  echo "-------------------------------------"

  ./table_menu.sh "$database_name"
}

set_primary_key() {
  while true; 
  do
    read -p "Choose which one is the primary key [ ${metadata[*]} ] : " result

    if [[ " ${metadata[@]} " =~ " $result " ]]; 
    then
      echo "PK:$result" >> "$table_meta_path.meta"
      echo "-------------------------------------"
      echo "Primary Key is $result"
      echo "-------------------------------------"
      break

    else
      # if the input doesn't match any one of the array of columns names
      echo "-------------------------------------"
      echo "Invalid value"
      echo "-------------------------------------"
    fi
  done
}

create_table() {
  list_available_tables
  get_table_name
  check_valid_table_name
  check_table_exists
  create_table_meta_path
  create_table_columns
}

create_table