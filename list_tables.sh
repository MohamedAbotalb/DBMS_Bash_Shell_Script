#!/bin/bash

database_name=$1
database_dir="./Databases/$database_name"

list_tables() {
  if [[ $(ls "$database_dir") ]]; then
    echo "-------------------------------------"
    echo "--------- Available Tables ----------"
    ls "$database_dir"
    echo "-------------------------------------"
  else
    echo "-------------------------------------"
    echo "---- There is no Database found -----"
    echo "-------------------------------------"
  fi

  ./table_menu.sh "$database_name"
}

list_tables "$database_name"
