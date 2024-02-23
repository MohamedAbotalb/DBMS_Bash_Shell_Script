#!/bin/bash

source table_functions.sh

get_old_row() {
  while true;
  do
    # Ask the user to enter the value of the primary key
    read -p "Enter the value of the primary key [$pk] to select a row: " PK

    if [[ $dtype = "int" && "$PK" = +([0-9]) || $dtype = "string" && "$PK" = +([a-zA-Z@.]) ]]
    then
      # Check if the PK value is present or not
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
        # Get the selected row to update its data
        get_target_row

        while true;
        do
          # Ask the user to enter the column name to update its value
          read -p "Enter the column name you want to update its value [ ${metadata[*]} ]: " column_name

          flag=0
          position=0
          for meta in "${metadata[@]}";
          do
            if [[ "$column_name" = "$meta" ]];
            then
              flag=1
              break
            else
              ((position++))
            fi
          done

          if [[ $flag = 0 ]];
          then
            # if the input is not match any one of the array of columns names
            echo "-------------------------------------"
            echo "Invalid value"
            echo "-------------------------------------"

          else
            while true; 
            do
              name="${metadata[$position]}"
              type="${datatypes[$position]}"
              
              read -p "Enter the new value of [$name]: " value
                
              if [[ $type = "int" && "$value" = +([0-9]) || $type = "string" && "$value" = +([a-zA-Z@.]) ]]; then
                if [[ "$name" = "$pk" ]]; 
                then
                  flag=0
                  for val in "${pk_values[@]}"; 
                  do
                    if [[ "$val" = "$value" ]];
                    then
                      flag=1
                      echo "-------------------------------------"
                      echo "This value of Primary Key is present before, please enter a new ${name} value"
                      echo "-------------------------------------"
                    fi
                  done

                  if [[ $flag -eq 0 ]]; 
                  then
                    break 3
                  fi
                else
                  break 3
                fi
              else
                echo "-------------------------------------"
                echo "Invalid input, please enter a valid ${name} value"
                echo "-------------------------------------"
              fi
            done
          fi
        done
      fi

    else
      echo "-------------------------------------"
      echo "The value of $pk is invalid, enter a new value"
      echo "-------------------------------------"
    fi
  done
}

create_new_row() {
   # target_row => new_row with the updated value
  new_row=$(echo "$target_row" | awk -F: -v new_val="$value" -v pos="$position" '{$(pos+1) = new_val} 1' | sed 's/ /:/g')

  # Get the number of target_row 
  row_number=$(awk -F: -v pattern="$PK" '$'$((index+1))' == pattern {print NR; exit}' "$table_name_path")

  # Remove the target_row from the table and then create the new_row and replace the new_row with the target_row
  awk -v row_number="$row_number" -v new_row="$new_row" 'NR == row_number { print new_row; next } { print }' "$table_name_path" > temp.txt && mv temp.txt "$table_name_path"

  echo "-------------------------------------"
  echo "The Row is Updated Successfully"
  echo "-------------------------------------"
}

update_record() {
  list_available_tables
  get_table_name
  check_valid_table_name || update_record
  check_table_exists || update_record
  create_table_meta_path
  check_data_presence
  get_metadata_and_datatypes
  get_pk_name
  get_pk_index
  get_pk_values
  get_pk_dtype
  get_old_row
  create_new_row
  ./table_menu.sh $database_name
}

update_record
