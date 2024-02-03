#!/bin/bash

# Check if the input contains space or not
# Use $# (number of arguments)
if [[ $# -gt 1 ]];
then
  echo "Invalid input, please don't use space in the name"
fi

# check the input value should start with at least 2 characters and may contain numbers and _ only
value=$1
pattern="^[a-zA-Z]{2,}[a-zA-Z0-9_]*$"

if [[ ! $value =~ $pattern ]]
then
  echo "Invalid input, please enter a valid value"
fi
