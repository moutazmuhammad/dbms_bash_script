#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name

function createTable
{
echo -e "\nEnter Table name: "
read table_name

case $table_name in
	+([a-zA-Z])) # work by using [shopt -s extglob]
		if [ ! -f $path/$table_name ]
		then
			touch ./my_dbms/$select_name/$table_name;
			
			echo -e 'Table Created Successfully.\n'
			sleep 1
			. ./use_db.sh
		else 
			echo "Table ($table_name) is Exist."
			sleep 1
			createTable
		fi 
			;;
	*) echo -e "\nTable name can not contain number or spesial characters.\nplease, Try again..."	  
	   createTable ;;
esac
}
createTable
