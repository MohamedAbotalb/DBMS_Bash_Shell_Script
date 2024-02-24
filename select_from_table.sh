
Copy code
#!/bin/bash

# Source the table functions script
source table_functions.sh

# Function to select all rows from a table
select_all_rows() {
  # Display a separator line
  echo "-------------------------------------"

  # Display the header of the table
  head -1 $table_meta_path.meta

  # Display another separator line
  echo "-------------------------------------"

  # Display the content of the table
  cat $table_name_path

  # Display another separator line
  echo "-------------------------------------"

  # Call the table menu script
  ./table_menu.sh $database_name
}

# Function to select a specific row from a table
select_specific_row() {
  # Get the primary key name
  get_pk_name

  # Get the primary key index
  get_pk_index

  # Get the primary key data type
  get_pk_dtype

  # Loop indefinitely
  while true;
  do
    # Prompt the user to enter the value of the primary key
    read -p "Enter the value of the primary key [$pk]: " PK

    # Check if the entered value is valid
    if [[ $dtype = "int" && "$PK" = +([0-9]) || $dtype = "string" && "$PK" = +([a-zA-Z@.]) ]];
    then
      # Get the primary key values
      get_pk_values

      # Initialize a flag variable to 0
      local flag=0

      # Loop through the primary key values
      for val in "${pk_values[@]}";
      do
        # If the entered value matches a primary key value
        if [[ "$PK" = "$val" ]];
        then
          # Set the flag to 1
          flag=1

          # Break out of the loop
          break
        fi
      done

      # If the entered value is not valid
      if [[ $flag = 0 ]];
      then
        # Display a separator line
        echo "-------------------------------------"

        # Display an error message
        echo "The value of $pk isn't present in the table, enter a new value"

        # Display another separator line
        echo "-------------------------------------"

      # If the entered value is valid
      else
        # Loop through the table content
        while IFS=: read -r -a fields;
        do
          # If the primary key value matches the current row's primary key value
          if [[ "${fields[$index]}" = "$PK" ]];
          then
            # Display a separator line
            echo "-------------------------------------"

            # Display the header of the table
            head -1 $table_meta_path.meta

            # Display another separator line
            echo "-------------------------------------"

            # Display the selected row
            echo "${fields[*]}" | sed 's/ /:/g' # sed replaces space with :

            # Display another separator line
            echo "-------------------------------------"

            # Break out of the loop
            break 2
          fi
        done < "$table_name_path"
      fi
    else
      # Display a separator line
      echo "-------------------------------------"

      # Display an error message
      echo "The value of $pk is invalid, enter a new value"

      # Display another separator line
      echo "-------------------------------------"
    fi
  done

  # Call the table menu script
  ./table_menu.sh $database_name
}

# Function to select rows from a table
select_from_table() {
  # List the available tables
  list_available_tables

  # Get the table name
  get_table_name

  # Check if the table name is valid
  check_valid_table_name || select_from_table

  # Check if the table exists
  check_table_exists || select_from_table

  # Create the table metadata path
  create_table_meta_path

  # Check if the table has data
  check_data_presence

  # Get the metadata and data types of the table
 
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
