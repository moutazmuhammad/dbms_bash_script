#!/bin/bash

echo -e "\n-------------------------"
        echo -e "** The Avelable Tables"
        echo -e "-------------------------\n"
        ls ./my_dbms/$select_name ;
        echo -e "\n"
function dropTable {
   
             read -p "~> Please, Enter Table Name you want to delete: " Tname
               if [ ! -e ~/my_dbms/$select_name/$Tname ]

                  then
                echo -e "\nThe name you entered is incorrect, Please enter correct name\n";
                dropTable;
        else
                rm  ./my_dbms/$select_name/$Tname
                echo "Table has been deleted successfully."
                sleep 1
        fi
}
dropTable
