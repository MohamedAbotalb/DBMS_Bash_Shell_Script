#!/bin/bash

# Ask the user for the table name
read -p "Enter the name of the table to delete: " table_name

# Check if the file exists
if [ -f "$table_name" ]; then

    read -p "Are you sure you want to delete $table_name? (y/n): " confirmation

    if [ "$confirmation" = "y" ]; then
        # Delete the file
        rm "$table_name"
        echo "Table $table_name deleted successfully."
    else
        echo "Deletion canceled."
    fi
else
    echo "Table $table_name does not exist."
fi
