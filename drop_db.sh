#!/bin/bash

echo -e "\n-------------------------"
	echo -e "** The Avelable Databases"
	echo -e "-------------------------\n"
	ls ~/my_dbms;
	echo -e "\n"

function dropDatabase
{
        read -p "~> Please, Enter Database Name you want to delete: " name

	if [ ! -d ~/my_dbms/$name ]
	then
		echo -e "\nThe name you entered is incorrect, Please enter correct name\n";
	       	dropDatabase;
	else
		rm -r ~/my_dbms/$name
               	echo "Database has been deleted successfully."
		sleep 1
	fi
}

dropDatabase
. ./root_menu.sh
