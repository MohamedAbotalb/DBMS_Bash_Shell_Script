#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name

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

read -p "Enter the table name you want to delete from: " table_name

# check if the table name is not valid
if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"

  ./drop_record.sh $database_name

# Check if the table name is present in the selected database
elif [[ ! -f $database_dir/$table_name ]];
then
  echo "-------------------------------------"
  echo "$table_name isn't present, please enter a new name"
  echo "-------------------------------------"

  ./drop_record.sh $database_name

else
  table_name_path=$database_dir/$table_name
  table_meta_path=$database_dir/.metadata/$table_name 

  # Check if the file is empty
  if [[ ! -s "$table_name_path" ]]; 
  then
    echo "-------------------------------------"
    echo "This table is empty."
    echo "-------------------------------------"
  else
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

    # Get the datatype value for the PK
    dtype="${datatypes[$index]}"

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
          while IFS=: read -r -a fields; 
          do
            if [[ "${fields[$index]}" = "$PK" ]]; 
            then
              # Get the target row
              target_row=$(echo "${fields[*]}" | sed 's/ /:/g') # sed replaces space with :
            fi
          done < "$table_name_path"

          while true;
          do
            read -p "Are you sure you want to delete this row? (y/n): " choice
            case $choice in

            [Yy] ) 
                sed -i "/$target_row/d" $table_name_path
                echo "---------------------------------------------"
                echo "Row in $table_name is table deleted successfully!"
                echo "---------------------------------------------"
                break 2
                ;;

            [Nn] )
                echo "----------------------"
                echo "Cancel delete!"
                echo "----------------------"
                break 2
                ;;

            * ) 
                echo "--------------------------"
                echo "Please choose y/n"
                echo "--------------------------"
                ;;
            esac
          done    
        fi
      else
        echo "-------------------------------------"
        echo "The value of $pk is invalid, enter a new value"
        echo "-------------------------------------"
      fi
    done
  fi
fi

./table_menu.sh $database_name
