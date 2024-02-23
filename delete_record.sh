#!/bin/bash

source table_functions.sh

delete_row() {
  get_target_row
  
  while true; 
  do
    read -p "Are you sure you want to delete this row? (y/n): " choice
    case $choice in
      [Yy] ) 
          sed -i "/$target_row/d" $table_name_path
          echo "---------------------------------------------"
          echo "Row in $table_name table deleted successfully!"
          echo "---------------------------------------------"
          break
          ;;
      [Nn] )
          echo "----------------------"
          echo "Cancel delete!"
          echo "----------------------"
          break
          ;;
      * ) 
          echo "--------------------------"
          echo "Please choose y/n"
          echo "--------------------------"
          ;;
    esac
  done
}

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

  while true; 
  do
    read -p "Enter the value of the primary key [$pk] to select a row: " PK

    if [[ $dtype = "int" && "$PK" = +([0-9]) || $dtype = "string" && "$PK" = +([a-zA-Z@.]) ]]; 
    then
      flag=0
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
      else
        delete_row
        break
      fi
    else
      echo "-------------------------------------"
      echo "The value of $pk is invalid, enter a new value"
      echo "-------------------------------------"
    fi
  done

  ./table_menu.sh $database_name
}

delete_record
