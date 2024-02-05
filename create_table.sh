#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name

read -p "Enter the table name: " table_name

result=`./check_valid_value.sh $table_name`

# check if the table name is not valid
if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"

  ./create_table.sh $database_name

# Check if the table name is present in the selected database
elif [[ -f $database_dir/$table_name ]];
then
  echo "-------------------------------------"
  echo "$table_name is present, please enter a new name"
  echo "-------------------------------------"

  ./create_table.sh $database_name

else
  # The table name is valid and not found in the database
  # check if the columns number is a positive decimal only
  while true;
  do
    read -p "Enter the number of columns: " columns

    if [[ $columns =~ ^[1-9]+$ ]]; 
    then
      break

    else
      echo "-------------------------------------"
      echo "Invalid columns number"
      echo "-------------------------------------"

    fi
  done

  # Declare an array to hold the columns name
  metadata=()

  # Get the name of each column and check its value is valid or not and contains at least 2 characters
  for ((i=1; i <= $columns; i++))
  do
    while true;
    do
      read -p "Enter the name of column $i: " name

      if [[ $name =~ ^[a-zA-Z]{2,}[a-zA-Z_]*$ || $name =~ *" "* ]]
        then
          metadata+=("$name")
          break

      else
        echo "-------------------------------------"
        echo "Invalid column name"
        echo "-------------------------------------"

      fi
      
    done

    # set the data type for each column (string/integer)
    # check if the datatype is not (string/integer) or the value is not entered (-z) 
    while true;
    do
      read -p "Enter the datatype of column $i [string/int]: " datatype

      if [[ "$datatype" != *(int)*(string) || -z "$datatype" ]]
      then
        echo "-------------------------------------"
        echo "Invalid datatype"
        echo "-------------------------------------"

      else
        break

      fi
    done

    # set each column name in a file of metadata (table_name.meta)
    # set each column datatype in a file of datatype (table_name.dtype)
    metadata_dir="./Databases/$database_name/.metadata"

    if [[ ! -d $metadata_dir ]] 
    then
      mkdir $metadata_dir
    fi
    
    if [[ i -eq $columns ]]; 
    then
      echo $name >> $metadata_dir/$table_name.meta
      echo $datatype >> $metadata_dir/$table_name.dtype

    else
      echo -n $name":" >> $metadata_dir/$table_name.meta
      echo -n $datatype":" >> $metadata_dir/$table_name.dtype
    fi
  done

  # set the primary key to a specific column 
  while true;
  do
    read -p "Choose which one is the primary key [ ${metadata[*]} ] : " result

    for meta in "${metadata[@]}";
    do
      if [[ "$result" = "$meta" ]];
      then
        echo "PK:"$result >> $metadata_dir/$table_name.meta

        echo "-------------------------------------"
        echo "primary key is $result"
        echo "-------------------------------------"

        break 2     
      fi
    done

    # if the input is not match any one of the array of columns names
    echo "-------------------------------------"
    echo "Invalid value"
    echo "-------------------------------------"
  done
  
  touch $database_dir/$table_name
  echo "-------------------------------------"
  echo "$table_name table is created successfully"
  echo "-------------------------------------"

  ./table_menu.sh $database_name
fi
