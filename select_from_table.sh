#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name
metadata_dir=$database_dir/.metadata

echo "-------------------------------------"
echo "Available tables in $database_name:"
ls $database_dir
echo "-------------------------------------"

read -p "Enter the table name to select from: " table_name

result=`./check_valid_value.sh $table_name`

# check if the table name is not valid
if [[ $result ]];
then
  echo "-------------------------------------"
  echo $result
  echo "-------------------------------------"

  ./select_from_table.sh $database_name

# Check if the table name isn't present in the selected database
elif [[ ! -f $database_dir/$table_name ]];
then
  echo "-------------------------------------"
  echo "$table_name isn't present, please enter a new name"
  echo "-------------------------------------"

  ./select_from_table.sh $database_name

else
  table_name_path=$database_dir/$table_name
  table_meta_path=$database_dir/.metadata/$table_name

  PS3="Choose what you want: "
  select choice in "Select All" "Select Specific Row"
  do
    case $REPLY in
      # Select all rows
      1)
        # Check if the table contains data or not
        if [[ ! -s "$table_name_path" ]]; 
        then
          echo "-------------------------------------"
          echo "This table is empty."
          echo "-------------------------------------"
        else
          echo "-------------------------------------"
          head -1 $table_meta_path.meta
          echo "-------------------------------------"
          cat $table_name_path
          echo "-------------------------------------"
        fi

        ./table_menu.sh $database_name
        ;;

      # Select specific row
      2)
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

          # Get the datatype value for the PK
          dtype="${datatypes[$index]}"

          while true;
          do
            # Ask the user to enter the value of the primary key
            read -p "Enter the value of the primary key [$pk]: " PK

            if [[ $dtype = "int" && "$PK" = +([0-9]) || $dtype = "string" && "$PK" = +([a-zA-Z@.]) ]]
            then 
              
              # Get the PK values to check if the entered value is present or not
              pk_values=($(awk -F: "{print \$($index+1)}" "$table_name_path"))

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
                while IFS=: read -r -a fields; 
                do
                  if [[ "${fields[$index]}" = "$PK" ]]; 
                  then
                    # Display the row
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
        fi

        ./table_menu.sh $database_name
        ;;

      *)
        echo "$REPLY is not one of the choices"
        ;;
    esac
  done
fi
