#!/bin/bash

function dropDatabase
{
	echo -e "\n--> Available Databases:\n"
	ls ~/my_dbms

	echo -e "\nPlease, Enter Database Name: "
        read name
	if [ -d ~/my_dbms/$name ]
	then
		echo -e "\nThe name you entered is incorrect, Please enter a valid name\n";
	       	dropDatabase;
	else
		rm -r $name
               	echo "Database has been deleted successfully."
		sleep 2
	fi
}

dropDatabase
. ~/root_menu.sh

