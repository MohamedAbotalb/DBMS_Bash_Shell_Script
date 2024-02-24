#!/bin/bash

# Check if the input contains space or not
if [[ $# -gt 1 ]]
then
  # If there are more than 1 arguments, it means there is a space in the input name
  echo "Invalid input, please don't use space in the name"
fi

# check the input value should start with at least 2 characters and may contain numbers and _ only
value=$1
pattern="^[a-zA-Z]{2,}[a-zA-Z0-9_]*$"

# The pattern checks for the following conditions:
# - The input value should start with at least 2 alphabetic characters (uppercase or lowercase)
# - The remaining characters can be alphanumeric (letters or numbers) or an underscore (_)

if [[ ! $value =~ $pattern ]]
then
  # If the input value does not match the pattern, it is considered invalid
  echo "Invalid input, please enter a valid value"
fi
