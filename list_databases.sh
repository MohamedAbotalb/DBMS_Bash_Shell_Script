#!/bin/bash

# Check if there is a database in the Databases direcotry or not
if [[ $(ls Databases) ]];
then
  echo "-------------------------------------"
  ls Databases
  echo "-------------------------------------"

else
  echo "-------------------------------------"
  echo "There is no Database found"
  echo "-------------------------------------"

fi

./main.sh