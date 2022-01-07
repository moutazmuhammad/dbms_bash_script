#!/bin/bash
shopt -s extglob

dir="my_dbms" 
mkdir -p ./$dir # Make main directory has all databases directories if not exist.
clear

echo -e "by: \t Moutaz Muhammad \t & \t Muhammad Alaa"

echo -e "\n                    WELCOME TO OUR DBMS\n"

# Main Function: Each number executes a script. 
function RootMenu 
{

	echo "            o<><><><><><><><><><><><><><><><>o"
	echo "            |                                |"
	echo "            |  1 -> Create New Database      |"
	echo "            |  2 -> List Databases           |"
	echo "            |  3 -> Use  Database            |"
	echo "            |  4 -> Drop Database            |"
	echo "            |  5 -> Exit From DBMS           |"
	echo "            |                                |"
	echo -e "            o<><><><><><><><><><><><><><><><>o\n"

	read -p "~> Please, Enter a number: " num

	case $num in
  		1) . ./create_db.sh ;;
  		2) ListDatabases ;; # call function
  		3) UseDatabase ;;
		4) . ./drop_db.sh ;;
		5) exit 
			clear ;;
		*) echo "* Wrong Choise! please Enter Correct Number..."; RootMenu;;
	esac

}


function ListDatabases
{
	num=`ls ./my_dbms/ | wc -l`
	if [[ $num == "0" ]]
	then
		echo -e "\n* There is no Avelable Database....\n"
		sleep 1
		. ./root_menu.sh
	else
		echo -e "\n--------------------------"
		echo -e "** The Avelable Databases"
		echo -e "--------------------------\n"
		ls ./my_dbms/
		echo -e "\n\n"
		RootMenu; # after list the content execute the function again.
	fi
}

function UseDatabase
{
	num=$(ls ./my_dbms/ | wc -l) # get number of folders in directory
	
	if [[ $num -eq 0 ]]
	then

		echo -e "\n* There is no Avelable Database... \n"
		sleep 1
		. ./root_menu.sh

	else
		echo -e "\n--------------------------"
		echo -e "** The Avelable Databases"
		echo -e "--------------------------\n"
		ls ./my_dbms/
		echo -e "\n\n"

		export select_name
		read -p "~> Please Enter Database Name: " select_name

		if [[ $select_name == +([a-zA-Z]) ]]
		then
			if [ -d ./my_dbms/$select_name ]
			then
				. ./use_db.sh
			else
				echo -e "\n* Database ($select_name) dose not exist.\n"
				UseDatabase
			fi
		else
			echo -e "\n* Database ($select_name) dose not exist.\n"
			UseDatabase
		fi

	fi
}

RootMenu
