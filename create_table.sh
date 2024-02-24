#!bin/bash

# Source the table functions library
source table_functions.sh

# Function to list available tables in the database directory
list_available_tables {
  if [[ls "$database_") ]]; then    echo "---------------------"
    echo "--------- Available Tables ----------"
    ls "$database_dir"
    echo "-------------------------------------"
  fi
}

# Function to check if a table already exists in the database directory
check_table_exists() {
  if [[ -f $database_dir/$table_name ]]; then
    echo "-------------------------------------"
    echo "$table_name is present, please enter a new name"
    echo "-------------------------------------"
    create_table # If table exists, prompt user to enter a new name
  fi
}

# Function to create metadata directory if it doesn't exist
create_metadata_dir() {
  if [[ ! -d $metadata_dir ]] then
    mkdir -p $metadata_dir
  fi
}

# Function to create table columns based on user input
create_table_columns() {
  create_metadata_dir

  # Loop until user enters a positive decimal number for columns
  while true; do
    read -p "Enter the number of columns: " columns

    if [[ $columns =~ ^[1-9][0-9]*$ ]]; then
      break
    else
      echo "-------------------------------------"
      echo "Invalid columns number"
      echo "-------------------------------------"
    fi
  done

  # Loop through each column and get its name and data type
  for ((i=1; i <= columns; i++)); do
    while true; do
      flag=0
      read -p "Enter the name of column $i: " name

      # Check if column name is valid (contains at least 2 characters and only alphabets or underscore)
      if [[ $name =~ ^[a-zA-Z]{2,}[a-zA-Z_]*$ || $name =~ *" "* ]]; then
        # Check if the column name is present before in the table or not
        for meta in "${metadata[@]}"; do
          if [[ "$name" = "$meta" ]]; then
            flag=1
            break
          fi
        done

        if [[ $flag = 0 ]]; then
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

    # Loop until user enters a valid data type (string or int)
    while true; do
      read -p "Enter the datatype of column $i [string/int]: " datatype

      if [[ "$datatype" != int && "$datatype" != string ]]; then
        echo "-------------------------------------"
        echo "Invalid datatype"
        echo "-------------------------------------"
      else
        break
      fi
    done

    # Write the column name and data type to the metadata files
    if [[ i -eq $columns ]]; then
      echo "$name" >> "$table_meta_path.meta"
      echo "$datatype" >> "$table_meta_path.dtype"
    else
      echo -n "$name:" >> "$table_meta_path.meta"
      echo -n "$datatype:" >> "$table_meta_path.dtype"
    fi
  done

  # Set the primary key for the table
  set_primary_key

  # Create the table file and display success message
  touch $table_name_path
  echo "-------------------------------------"
  echo "$table_name table is created successfully"
  echo "-------------------------------------"

  # Call the table menu function with the database name as an argument
  ./table_menu.sh $database_name
}

# Function to set the primary key for the table
set_primary_key() {
  while true; do
    read -p "Choose which one is the primary key [ ${metadata[*]} ] : " result

    # Check if the user input matches any of the column names
    if [[ " ${metadata[@]} " =~ " $result " ]]; then
      echo "PK:$result" >> "$table_meta_path.meta"
      echo "-------------------------------------"
      echo "Primary Key is $result"
      echo "-------------------------------------"
      break

    # If the input doesn't match any one of the array of columns names
    else
      echo "-------------------------------------"
      echo "Invalid value"
      echo "-------------------------------------"
    fi
  done
}

# Function to create a new table
create_table() {
  list_available_tables
  get_table_name
  check_valid_table_name || create_table # Check If table name is not valid, prompt user to enter a new name
  check_table_exists # Check if table already exists
  create_table_meta_path
  create_table_columns # Create table columns based on user input
}

# Call the create_table function to start the table creation process
create_table
