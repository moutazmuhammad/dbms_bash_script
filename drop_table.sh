#!/bin/bash

check_tb=`ls ./my_dbms/$select_name`
if [ $check_tb != "0" ]
then
    echo -e "\n-------------------------"
    echo -e "** The Avelable Tables"
    echo -e "-------------------------\n"
    ls ./my_dbms/$select_name ;
    echo -e "\n"
else
    echo -e "\n** There is no Avilable Table."
    sleep 1
    clear
    . ./use_db.sh
fi

function dropTable {
   
             read -p "~> Please, Enter Table Name you want to delete: " Tname
               if [ ! -f ~/my_dbms/$select_name/$Tname ]
               then
                echo -e "\n** The name you entered is incorrect, Please enter correct name\n";
                dropTable;
               else
                rm -r  ./my_dbms/$select_name/$Tname
                echo "** Table has been deleted successfully."
		sleep 1
		. ./use_db.sh
               fi
}
dropTable
