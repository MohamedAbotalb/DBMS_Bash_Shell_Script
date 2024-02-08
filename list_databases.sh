4. list_databases

#!/bin/bash

# List available databases
list_databases() {
  if [[ $(ls Databases) ]]; 
  then
    echo "-------------------------------------"
    echo "Available databases:"
    ls Databases
    echo "-------------------------------------"

  else
    echo "-------------------------------------"
    echo "There is no Database found"
    echo "-------------------------------------"
  fi
}

list_databases
./main.sh
