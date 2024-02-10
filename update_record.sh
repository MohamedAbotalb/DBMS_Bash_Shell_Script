#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name
metadata_dir="$database_dir/.metadata"

list_available_tables() {
  if [[ $(ls "$database_dir") ]]; 
  then
    echo "-------------------------------------"
    echo "--------- Available Tables ----------"
    ls "$database_dir"
    echo "-------------------------------------"
  else
    echo "-------------------------------------"
    echo "There us no table found"
    echo "-------------------------------------"

    ./table_menu.sh "$database_name"
  fi
}

get_table_name() {
  read -p "Enter the table name: " table_name
}

check_valid_table_name() {
  local result=$(./check_valid_value.sh "$table_name")

  if [[ $result ]]; 
  then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"

    update_record
  fi
}

check_table_exists() {
  if [[ ! -f "$database_dir/$table_name" ]]; 
  then
    echo "-------------------------------------"
    echo "$table_name isn't present, please enter a new name"
    echo "-------------------------------------"

    update_record
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

# Create an array to get the real data of primary key column in table file to compare the inserted PK value with them to disallow duplicates
get_pk_values() {
  pk_values=($(awk -F: "{print \$($index+1)}" "$table_name_path"))
}

# Get the datatype value for the PK
get_pk_dtype() {
  dtype="${datatypes[$index]}"
}

get_target_row() {
  while IFS=: read -r -a fields; 
  do
    if [[ "${fields[$index]}" = "$PK" ]]; 
    then
      # Display the row
      old_row=$(echo "${fields[*]}" | sed 's/ /:/g') # sed replaces space with :
      break
    fi
  done < "$table_name_path"
}

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
  # old_row => new_row with the updated value
  new_row=$(echo "$old_row" | awk -F: -v new_val="$value" -v pos="$position" '{$(pos+1) = new_val} 1' | sed 's/ /:/g')

  # Get the number of old_row 
  row_number=$(awk -v pattern="$PK" '$0 ~ pattern {print NR; exit}' "$table_name_path")

  # Remove the old_row from the table and then create the new_row and replace the new_row with the old_row
  awk -v row_number="$row_number" -v new_row="$new_row" 'NR == row_number { print new_row; next } { print }' "$table_name_path" > temp.txt && mv temp.txt "$table_name_path"

  echo "-------------------------------------"
  echo "The Row is Updated Successfully"
  echo "-------------------------------------"
}

update_record() {
  list_available_tables
  get_table_name
  check_valid_table_name
  check_table_exists
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
