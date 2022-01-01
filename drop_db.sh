#!/bin/bash

check_db=`ls ./my_dbms | wc -l`
if [ $check_db != "0" ]
then
	echo -e "\n-------------------------"
		echo -e "** The Avelable Databases"
		echo -e "-------------------------\n"
		ls ./my_dbms;
		echo -e "\n"
else
	echo -e "\n** There is no Avilavble Database"
	sleep 1
	clear 
	. ./root_menu.sh
fi

function dropDatabase
{
        read -p "~> Please, Enter Database Name you want to delete: " name

	if [ ! -d ./my_dbms/$name ]
	then
		echo -e "\n** The name you entered is incorrect, Please enter correct name\n";
	       	dropDatabase;
	else
		rm -r ./my_dbms/$name
               	echo "** Database has been deleted successfully."
		sleep 1
	fi
}

dropDatabase
. ./root_menu.sh
