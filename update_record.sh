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

read -p "Enter the table name you want to update: " table_name

# check if the table name is not valid
if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"

  ./update_record.sh $database_name

# Check if the table name is present in the selected database
elif [[ ! -f $database_dir/$table_name ]];
then
  echo "-------------------------------------"
  echo "$table_name isn't present, please enter a new name"
  echo "-------------------------------------"

  ./update_record.sh $database_name

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
              # Display the row
              old_row=$(echo "${fields[*]}" | sed 's/ /:/g') # sed replaces space with :
              
            fi
          done < "$table_name_path"

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
        fi

      else
        echo "-------------------------------------"
        echo "The value of $pk is invalid, enter a new value"
        echo "-------------------------------------"
      fi
    done

    # old_row => new_row with the updated value
    new_row=$(echo "$old_row" | awk -F: -v new_val="$value" -v pos="$position" '{$(pos+1) = new_val} 1' | sed 's/ /:/g')

    # Get the number of old_row 
    row_number=$(awk -v pattern="$PK" '$0 ~ pattern {print NR; exit}' "$table_name_path")

    # Remove the old_row from the table and then create the new_row and replace the new_row with the old_row
    awk -v row_number="$row_number" -v new_row="$new_row" 'NR == row_number { print new_row; next } { print }' "$table_name_path" > temp.txt && mv temp.txt "$table_name_path"

    echo "-------------------------------------"
    echo "The Row is Updated Successfully"
    echo "-------------------------------------"

  fi
fi

./table_menu.sh $database_name
