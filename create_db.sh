#!/bin/bash

shopt -s extglob #Lib treat

function createDB 
{
	echo -e "\n** Enter Database name: "
	read -p "~> " dbname

	case $dbname in
		+([a-zA-Z])) 
					mkdir ./my_dbms/$dbname 2>/dev/null;
			if [[ $? == 0 ]]
			then
				echo '* Database Created Successfully.'
				sleep 1
				. ./root_menu.sh
			else 
				echo "* Database ($dbname) is Exist." 
				createDB
			fi 
			;;
		*) echo -e "\n* Database name can not contain number or special characters.\nplease, Try again..."
		createDB ;;
	esac
}
createDB
