#!/bin/bash

# Make main directory has all databases directories if not exist.
cd ~
dir="my_dbms"
mkdir -p $dir

clear
echo -e "\n                   WELCOME TO MY DBMS\n"

# Main Function: Each number executes a script. 
function RootMenu 
{

	echo "            o<><><><><><><><><><><><><><><><>o"
	echo "            |                                |"
	echo "            |  1 -> Create New Database      |"
	echo "            |  2 -> List Databases           |"
	echo "            |  3 -> Use  Database            |"
	echo "            |  4 -> Drop Database            |"
	echo "            |  5 -> Exit                     |"
	echo "            |                                |"
	echo -e "            o<><><><><><><><><><><><><><><><>o\n"

	read -p "Please choose a number: " num

	case $num in
  		1) . ./create_db.sh ;;
  		2) ls ./my_dbms; RootMenu;; # after list the content execute the function again.
  		3) . ./use_db.sh ;;
    		4) . ./drop_db.sh ;;
      		5) exit ;;
		*) echo "Wrong Choise! please Enter Correct Number..."; RootMenu;;
	esac

}

RootMenu

