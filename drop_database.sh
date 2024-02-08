3. drop_database.sh file

#!/bin/bash

# List available databases
list_databases() {
  echo "-------------------------------------"
  echo "Available Databases:"
  ls ./Databases
  echo "-------------------------------------"
}

# Ask the user to enter database name
get_database_name() {
  read -p "Enter name of database: " database_name
}

# Check if the database name is valid
check_valid_database() {
  local database_name="$1"
  local result=$(./check_valid_value.sh "$database_name")

  if [[ $result ]]; 
	then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"

    main
  fi
}

check_database_exists() {
  local database_name="$1"
  local database_path="./Databases/$database_name"

  if [ ! -d "$database_path" ]; then
    echo "--------------------------------------"
    echo "Database $database_name doesn't exist!"
    echo "--------------------------------------"

    main
  fi
}

drop_database() {
  local database_name="$1"
  local database_path="./Databases/$database_name"

  while true; 
	do
    read -p "Are you Sure You Want To delete $database_name Database? y/n " choice
    case $choice in

      [Yy] ) 
        rm -r "$database_path"
        echo "---------------------------------------------"
        echo "Database $database_name is deleted successfully!"
        echo "---------------------------------------------"
        break 
				;;

      [Nn] )
        echo "---------------------------------------------"
        echo "Cancel delete!"
        echo "---------------------------------------------"
        break 
				;;

      * ) 
        echo "---------------------------------------------"
        echo "Please choose y/n"
        echo "---------------------------------------------" 
				;;
    esac
  done
	./main.sh
}

# Create main function to exectue all functions
main() {
  list_databases
  get_database_name
  check_valid_database "$database_name"
  check_database_exists "$database_name"
  drop_database "$database_name"
}

main
