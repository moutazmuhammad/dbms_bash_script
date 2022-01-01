#!/bin/bash

export select_name
read -p "Please, Enter Database Name: " select_name


function TableMenu
{
if [ -d ./my_dbms/$select_name ]
then

        echo -e "\n\n            o<><><><><><><><><><><><><><><><>o"
        echo "            |                                |"
        echo "            |  1 -> Create New Table         |"
        echo "            |  2 -> List Tables              |"
        echo "            |  3 -> Drop Tables              |"
        echo "            |  4 -> Insert Into Table        |"
        echo "            |  5 -> Select From Table        |"
        echo "            |  6 -> Delete From Table        |"
	echo "            |  7 -> Update Table             |"
	echo "            |  8 -> Back To Main Menu        |"
	echo "            |  9 -> Exit From DBMS           |"
	echo "            |                                |"
        echo -e "            o<><><><><><><><><><><><><><><><>o\n"

        read -p "Please, Enter a number: " num

        case $num in
                1) . ./create_table.sh ;;
                2) ListTables; TableMenu;; # after list the content execute the function again.
                3) . ./drop_table.sh ;;
                4) . ./insert_into_table.sh ;;
		5) . ./select_from_table.sh ;;
		6) . ./delete_from_table.sh ;;
		7) . ./update_table ;;
		8) . ./root_menu.sh ;;
                9) exit ;;
                *) echo "Wrong Choise! please Enter Correct Number..."; TableMenu;;
        esac
else
	echo -e "\nDatabase ($select_name) dose not Exist.\n" 
	. ./use_db.sh
fi
}

function ListTables
{
	db_number=`ls ./my_dbms/$select_name | wc -l`
	if [[ $db_number == "0" ]]
	then
		echo -e "There is no Avelable Table...\n"
		sleep 1
		clear
		. ./use_db.sh
	else
		echo -e "\n-----------------------"
		echo -e "** The Avelable Tables"
		echo -e "-----------------------\n"
		ls ./my_dbms/$select_name
		echo -e "\n\n"
		TableMenu; # after list the content execute the function again.
	fi
}

TableMenu
