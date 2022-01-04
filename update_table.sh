#!/bin/bash
path=./my_dbms/$select_name

db_number=`ls $path | wc -l`
if [[ $db_number == "0" ]]
then
    echo -e "\n* There is no Avelable Table...\n"
    sleep 1
    clear
    . ./use_db.sh
fi

echo -e "\n** Enter Table name: "
    read -p "~> " table_name

if [ ! -f $path/$table_name ]
then
    echo -e "\n* Table ($table_name) is not Exist.\nPlease try again... \n"
    sleep 1
    . ./use_db.sh
fi

function Ubdate_table 
{    


	echo -e "\n** Enter Primary key value: "
    read -p "~> " Pkey

	Pkcheck=`awk -F: '{if ($1 == "'$Pkey'") print 1}' $path/$table_name` # this line check if PK is exist (will print 1)
	if  [[ $Pkcheck -eq 1 ]]
        then
            row_num=`awk -F: '{if ($1 == "'$Pkey'"){print NR}}' $path/$table_name` # this line get number of line with primary key $Pkey
        else
		echo "* The primary key you entered is wrong!"
        sleep 1
		Ubdate_table
	fi



	echo -e "\n** Enter Column Name: "
    read -p "~> " selected_col_name

	cols_num=`awk -F: '{if(NR==1) print NF}' $path/$table_name` #number of columns in table col+1

	for (( i=1 ; i<$cols_num ; i++ ))
    do

		specific_col_name=`cat $path/$table_name | head -1 | cut -d: -f$i` # each loop this variable=new field in line

		if [[ $selected_col_name == $specific_col_name ]]
		then 

			echo -e "\* Enter new Value to set: "
        	read newValue

            oldValue=`awk -F: '{if(NR=="'$row_num'") print $0}' $path/$table_name | cut -d: -f$i` # this line git the old value

			sed -i ''$row_num's/'$oldValue'/'$newValue'/g' $path/$table_name # replace old value by new one
        
            echo -e "* Row updated successfully.\n"

		fi
	done


	echo -e "\nPress [b] return to previous menu ."
	read -p "~> " back
	while true
	do
		if [[ $back == 'b' || $b == 'b' ]]
		then
			TableMenu
		else
			echo -e "\nPress [b] return to previous menu ."
			read -p "~> " b
		fi
	done

}

Ubdate_table










