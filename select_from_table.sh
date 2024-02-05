#!/bin/bash

database_name=$1

read -p "Enter table name you want to select from: " table_name
table_path=DataBases/$database_name/$table_name

result=`./check_valid_value.sh $table_name`

if [[ $result ]];
    echo ""
# Ask the user what they want to select
echo "What do you want to select?"
echo "1. Whole file"
echo "2. One row"
read -p "Enter your choice : " choice

if [ "$choice" == "1" ]; then
    # Display the whole students file
    head -1 ./Databases/$database_name/.metadata/$table_name
    cat $table_path
elif [ "$choice" == "2" ]; then
    # Ask the user to enter the value of the primary key
    read -p "Enter the value of the primary key: " primary_key

    # Find the corresponding row in the students file
    row=$(grep "$Pk" ./Databases/$databas_name/$table_name)

    # Display metadata as the first line and the corresponding row
    echo "$(head -1 Databases/.metadata/$database_name/$table_name.meta)"
    echo "$row"
else
    echo "Invalid choice. Exiting."
    ./select_from_table.sh
fi

exit 0
