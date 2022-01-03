#!/bin/bash
path=./my_dbms/$select_name

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

	cols_num=`awk -F: '{if(NR==1) print NF}' $path/$table_name` #number of columns in row in table (col+1)

	for (( i=1 ; i<$cols_num ; i++ ))
    do
		specific_col_name=`cat $path/$table_name | head -1 | cut -d: -f$i` # get name of column that entered by user

		if [[ $selected_col_name == $specific_col_name ]]
		then 
			res=`awk -F: '{if(NR=="'$row_num'") print $0}' $path/$table_name | cut -d: -f$i`

			echo -e "\* Enter new Value to set: "
        	read newValue

            result=`awk -F: '{if(NR=="'$row_num'") print $0}' $path/$table_name | cut -d ':' -f$specific_col_num`
			new=`awk -F: '{if(NR=="'$row_num'") print $0}' $path/$table_name | sed 's/"'$result'"/"'$newValue'"'`
        
            echo "Row updated successfully"
			sleep 1
		fi

	done


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

Ubdate_table










