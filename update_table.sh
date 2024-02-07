#!/bin/bash

database_name=$1
database_dir=./Databases/$database_name

read -p "Enter the table name you want to update: " table_name

# Ask user to input an ID to update
read -p "Enter the ID you want to update: " selected_id

# Validate if the selected ID exists in the file
if ! grep -q "^$selected_id :" ./Databases/$1/$table_name/.metadata; then
    echo "Invalid ID. Exiting."
    exit 1
fi

# Display the selected row
echo "Selected row:"
awk -F ' : ' -v id="$selected_id" '$1 == id {print $0}' file

# Ask user which field to update
read -p "Which field do you want to update : " field_to_update

# Validate the field input
if [ "$field_to_update" != "name" ] && [ "$field_to_update" != "email" ]; then
    echo "Invalid field. Exiting."
    exit 1
fi

# Ask user for the new value
read -p "Enter the new $field_to_update: " new_value

# Update the data in the file
awk -F ' : ' -v id="$selected_id" -v field="$field_to_update" -v value="$new_value" 

echo "Data updated successfully."
