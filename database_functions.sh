#!/bin/bash

get_database_name() {
  read -p "Enter name of database: " database_name
}

check_valid_database() {
  local database_name=$1
  local result=$(./check_valid_value.sh $database_name)

  if [[ $result ]]; 
  then
    echo "-------------------------------------"
    echo "$result"
    echo "-------------------------------------"
    
    main
  fi
}

check_database_presence_to_create() {
  local database_name=$1
  local database_dir=./Databases/$database_name

  if [[ -d "$database_dir" ]]; 
  then
    echo "--------------------------------------"
    echo "$database_name is already present, please enter a new name"
    echo "--------------------------------------"
    
    main
  fi
}

check_database_presence_to_connect() {
  local database_name=$1
  local database_dir=./Databases/$database_name

  if [[ ! -d "$database_dir" ]]; 
  then
    echo "--------------------------------------"
    echo "Database $database_name doesn't exist!"
    echo "--------------------------------------"
    
    main
  fi
}

list_databases() {
  if [[ $(ls Databases) ]]; 
  then
    echo "-------------------------------------"
    echo "-------- Available Databases --------"
    ls Databases
    echo "-------------------------------------"
    
  else
    echo "-------------------------------------"
    echo "---- There is no Database found -----"
    echo "-------------------------------------"
  fi
}

confirm_delete_database() {
  local database_name=$1
  local database_dir=./Databases/$database_name

  while true; 
  do
    read -p "Are you Sure You Want To delete $database_name Database? y/n " choice
    case $choice in
      [Yy] )
        rm -r $database_dir
        echo "-------------------------------------"
        echo "Database $database_name is deleted successfully!"
        echo "-------------------------------------"
        break
        ;;
        
      [Nn] )
        echo "-------------------------------------"
        echo "Cancel delete!"
        echo "-------------------------------------"
        break
        ;;
        
      * )
        echo "-------------------------------------"
        echo "Please choose y/n"
        echo "-------------------------------------"
        ;;
    esac
  done
}
