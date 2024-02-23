#!/bin/bash

source table_functions.sh

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
  check_valid_table_name || select_from_table
  check_table_exists || select_from_table
  create_table_meta_path
  check_data_presence
  get_metadata_and_datatypes
}

select_from_table

PS3="Choose what you want: "
select choice in "Select All" "Select Specific Row"; 
do
  case $REPLY in

  1)
    select_all_rows
    ;;

  2)
    select_specific_row
    ;;

  *)
    echo "$REPLY is not one of the choices"
    ;;
  esac
done
