 #!/bin/bash
 echo -e "Enter Database Name: \c"
 read -r database_name

  cd ./DataBases/$database_name 2> /dev/null
  
if [ $? -eq 0 ]

  then
    echo "========================================="
    echo "Connected to $database_name Successfully!"
    echo "========================================="
    cd ..
    cd ..
    
    ./main.sh

  else
    echo "================================"
    echo "Database $database_name not found!"
    echo "================================"
    ./main.sh

fi
       