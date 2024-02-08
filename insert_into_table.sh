#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name
metadata_dir=$database_dir/.metadata

if [[ $(ls $database_dir) ]];
then
  echo "-------------------------------------"
  echo "Available Tables in $database_name:"
  ls $database_dir
  echo "-------------------------------------"

else
  echo "-------------------------------------"
  echo "There is no tables found"
  echo "-------------------------------------"

  ./table_menu.sh $database_name
fi

read -p "Enter the table name: " table_name

result=`./check_valid_value.sh $table_name`

# check if the table name is not valid
if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"

  ./insert_into_table.sh $database_name

# Check if the table name isn't present in the selected database
elif [[ ! -f $database_dir/$table_name ]];
then
  echo "-------------------------------------"
  echo "$table_name isn't present, please enter a new name"
  echo "-------------------------------------"

  ./insert_into_table.sh $database_name

else
  table_name_path=$database_dir/$table_name
  table_meta_path=$database_dir/.metadata/$table_name

  # Get the primary key value from the metadata file
  meta=`awk 'NR==2 {print}' $table_meta_path.meta`
  pk=$(echo "$meta" | awk -F: '{print $2}')

  # Create an array to get the columns names from meta file
  metadata=($(awk -F: 'NR==1 {for(i=1;i<=NF;i++) print $i}' $table_meta_path.meta))

  # Create an array to get the columns datatypes from dtype file
  datatypes=($(awk -F: 'NR==1 {for(i=1;i<=NF;i++) print $i}' $table_meta_path.dtype))

  # Read the second line and get the index of the value after ":"
  for((i=0; i < ${#metadata[@]}; i++)) 
  do
    if [[ "$pk" = "${metadata[$i]}" ]];
    then
      index=$i
      break
    fi
  done

  # Create an array to get the real data of primary key column in table file to compare the inserted PK value with them to disallow duplicates
  pk_values=($(awk -F: "{print \$($index+1)}" "$table_name_path"))

  # Ask the user to insert the data for each column
  real_data=()
  length=${#metadata[@]}

  for((i=0; i < $length; i++)) 
  do
    name="${metadata[$i]}"
    type="${datatypes[$i]}"

    while true; 
    do
      # check if the column is the primary key
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
  echo "Data Inserted Successfully"
  echo "-------------------------------------"

  ./table_menu.sh $database_name

fi
