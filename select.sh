#!/bin/bash
shopt -s extglob

clear

path=./my_dbms/$select_name

# Check if table exist or not
echo -e "\n** Enter Table name: "
    read -p "~> " table_name

if [ ! -f $path/$table_name ]
then
    echo -e "\n* Table ($table_name) is not Exist.\nPlease try again... \n"
    sleep 1
    . ./insert.sh
fi


function SelectMenu
{
	clear
	echo -e "\n\n            o<><><><><><><><><><><><><><><><>o"
	echo "            |                                |"
	echo "            |  1 -> Select All Records       |"
	echo "            |  2 -> Select Specific Record   |"
	echo "            |  3 -> Select Specific Cokumn   |"
	echo "            |  4 -> Return to previous menu  |"
	echo "            |                                |"
    echo -e "            o<><><><><><><><><><><><><><><><>o\n"

	read -p "~> Please, Enter a number: " num

	case $num in
		1) SelectAllRecords ;;
		2) SelectRecord;;
		3) . ./select_specific_record.sh ;;
		4) . ./use_db.sh ;;
		*) echo "* Wrong Choise! please Enter Correct Number..."; sleep 1; clear; SelectMenu;;
	esac
}

function SelectAllRecords
{
    echo -e "\n-----------------------"
    echo -e "** The Avelable Records"
    echo -e "-----------------------\n"

	row_num=`awk -F: 'END{print NR}' $path/$table_name` # Number of record in table
	((row_num-=2)) # Number of records with out lines [1 (colum name) 2 (column type)]
	column -t -s':' $path/$table_name | tail -$row_num # column command [-t] print in columns [-s] separator

	echo -e "\nPress [b] return to previous menu ."
	read -p "~> " back

	while true
	do
		if [[ $back == 'b' || $b == 'b' ]]
		then
			SelectMenu
		else
			echo -e "\nPress [b] return to previous menu ."
			read -p "~> " b
		fi
	done

}

function SelectRecord
{

    echo -e "\n-----------------------"
    echo -e "** Records"
    echo -e "-----------------------\n"
	
    awk '{if(NR>2) print $0}' ./my_dbms/$select_name/$table_name

}

SelectMenu