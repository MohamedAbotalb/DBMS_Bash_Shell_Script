 #!/bin/bash
 read -p "Enter Database Name: " $database_name
   
if [ $? -eq 0 ]

  then
    echo "-----------------------------------------"
    echo "Connected to $database_name Successfully!"
    echo "-----------------------------------------"

    ./table_menu.sh

  else
    echo "----------------------------------"
    echo "Database $database_name not found!"
    echo "----------------------------------"
    
    ./main.sh

fi
       