#!/bin/bash

# Ask the user for the primary key
read -p "Enter the primary key to delete: " primary_key


    if [ -n "$row_number" ]; then
            # If the primary key is found, delete the corresponding row in the table file
            sed -i "${row_number}d" table.txt
            echo "Row with primary key $primary_key deleted successfully."
        else
            echo "Primary key $primary_key not found in the table."
    fi