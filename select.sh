#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name

db_number=`ls $path | wc -l`
if [[ $db_number == "0" ]]
then
    echo -e "\n* There is no Avelable Table...\n"
    sleep 1
    clear
    . ./use_db.sh
fi

# Check if table exist or not
echo -e "\n** Enter Table name: "
    read -p "~> " table_name

if [ ! -f $path/$table_name ]
then
    echo -e "\n* Table ($table_name) is not Exist.\n  Please try again... \n"
    sleep 1
    . ./insert.sh
fi

# Check number of PK in table 
num_of_PK=`cat $path/$table_name | wc -l`
if  [[ $num_of_PK -eq 2 ]]
then
	echo -e "\n* There is no record in this table yet!"
	sleep 1
	. ./use_db.sh
fi


clear

function SelectMenu
{
	clear
	echo -e "\n\n            o<><><><><><><><><><><><><><><><>o"
	echo "            |                                |"
	echo "            |  1 -> Select All Records       |"
	echo "            |  2 -> Select Specific Record   |"
	echo "            |  3 -> Select Specific Column   |"
	echo "            |  4 -> Return To Previous Menu  |"
	echo "            |                                |"
    echo -e "            o<><><><><><><><><><><><><><><><>o\n"

	read -p "~> Please, Enter a number: " num

	case $num in
		1) SelectAllRecords ;;
		2) SelectRecord;;
		3) SelectSpecificRecord ;;
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

		column -t -s':' $path/$table_name | head -1
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

	echo -e "\n** Enter Primary key: "
    read -p "~> " Pkey

    

	Pcheck=`awk -F: '{if ($1 == "'$Pkey'" && NR>2) print 1}' $path/$table_name` # this line check if PK is exist (will print 1)
	if  [[ $Pcheck -eq 1 ]]
        then
			echo -e "\n----------------------------------------"
			echo -e "** Record data with Primary key [$Pkey] "
			echo -e "----------------------------------------\n"

            row_num=`awk -F: '{if ($1 == "'$Pkey'"){print NR}}' $path/$table_name` # this line get number of line with primary key $Pkey
			
			column -t -s':' $path/$table_name | head -1
            column -t -s':' $path/$table_name | awk '{if(NR=="'$row_num'") print $0}'
        else
		echo "* NO available data!"
        sleep 1
	fi

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

function SelectSpecificRecord
{

	echo -e "\n** Enter Primary key value: "
    read -p "~> " Pkey

	Pkcheck=`awk -F: '{if ($1 == "'$Pkey'" && NR>2) print 1}' $path/$table_name` # this line check if PK is exist (will print 1)
	if  [[ $Pkcheck -eq 1 ]]
        then
            row_num=`awk -F: '{if ($1 == "'$Pkey'"){print NR}}' $path/$table_name` # this line get number of line with primary key $Pkey
        else
		echo "* The primary key you entered is wrong!"
        sleep 1
		SelectSpecificRecord
	fi
	
	echo -e "\n** Enter Column Name: "
    read -p "~> " selected_col_name

	cols_num=`awk -F: '{if(NR==1) print NF}' $path/$table_name` #number of columns in table col+1

	((flag=1))
	for (( i=1 ; i<$cols_num ; i++ ))
    do


		specific_col_name=`cat $path/$table_name | head -1 | cut -d: -f$i`

		if [[ $selected_col_name == $specific_col_name ]]
		then 

		
			res=`awk -F: '{if(NR=="'$row_num'") print $0}' $path/$table_name | cut -d: -f$i` # this line print the record has primary key enterd by user
			echo -e "\n** [$selected_col_name] of record with Primary key [$Pkey] :"
			echo -e "--> $res"
			((flag=0))

		fi
	done

	if [[ $flag -eq 1 ]]
	then 

		echo -e "\n* Column name you entered is Worng!"
        sleep 1

	fi


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

SelectMenu