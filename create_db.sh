 #!/bin/bash
 function craeteDB {
 echo 'Enter database name: '
 read dbname
 mkdir ~/my_dbms/$dbname    2>/dev/null

 if [[ $? == 0 ]];
  then
 #ls  /my_dbms
  echo 'Database Created Successfully'
  else 
  
  echo "Erorr Craeting Database $dbname"
 fi
 RootMenu
 }
  craeteDB





