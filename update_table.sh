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

function UbdateColumn 
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
		UbdateColumn
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


function UpdateRecord
{
	((i=1))
	((flag=1))
	selection=""
	echo -e "\n** Enter Primary key value: "
    read -p "~> " Pkey


	Pkcheck=`awk -F: '{if ($1 == "'$Pkey'") print 1}' $path/$table_name` # this line check if PK is exist (will print 1)
	if  [[ $Pkcheck -eq 1 ]]
        then
            row_num=`awk -F: '{if ($1 == "'$Pkey'"){print NR}}' $path/$table_name` # get number of line with primary key $Pkey
        else
		echo "* The primary key you entered is wrong!"
        sleep 1
		UpdateRecord
	fi

	cols_num=$(awk -F: '{if(NR==1) print NF}' $path/$table_name) #number of columns in table col+1 (:)

	while [[ $i < $cols_num ]]
    do
	echo "Start ttttttttttttttttttt"

		col_name=$(awk -F: '{if(NR==1) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) # get name of column from line 1 each loop
        col_type=$(awk -F: '{if(NR==2) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) # get type of column from line 2 each loop
	
		echo -e "Do you want to update [$col_name]?"
		select allow in "yes" "no"
		do
			case $allow in
				"yes") selection="YES" ; break;;
				"no") selection="NO" ; ((i++)) ; ((flag=0)) ; break;;
				*) echo -e "\nWrong Choise... try again...\n";
			esac
		done

	
		if [[ $selection = "YES" ]]
		then
		echo "1"
			echo -e "\nPlease Enter new Value ..."
			read newColumn

			if [[ $col_type = "int" ]]
			then
				echo "2"
				if [[ $flag -eq 1 ]]
				then
					Pcheck=`awk -F: '{if ($1 == "'$newColumn'" && NR>2 && NR!="'$row_num'" ) print 1}' $path/$table_name`  # this line check if PK is exist (will print 1)
					if  [[ $Pcheck == "1" ]]
					then
					echo "3"
						echo -e "* Sorry, you can't duplicate the primary key.\n  please try again...\n"
						
						sleep 1
						continue
					fi
				fi

				if [[ $newColumn != +([0-9]) ]]
				then
				echo "4"
					echo -e "\n* Please, Enter INETGER number.\n  You will enter the data of record from beginning...\n"

					sleep 1
					continue

				else
				echo "5"
					oldColumn=`awk -F: '{if (NR=="'$row_num'") print $0}' $path/$table_name | cut -d: -f$i`
					sed -i ''$row_num's/'$oldColumn'/'$newColumn'/g' $path/$table_name
					((i++))
					((flag=0))
				fi
			fi


			# Check The values if String.
			if [[ $col_type = "str" ]]
			then
				echo "6"
				if [[ $flag -eq 1 ]]
				then
				echo "7"
					Pcheck=`awk -F: '{if ($1 == "'$newColumn'" && NR>2 && NR!="'$row_num'" ) print 1}' $path/$table_name`  # this line check if PK is exist (will print 1)

					if  [[ $Pcheck -eq 1 ]]
					then
					echo "8"
						echo -e "* Sorry, you can't duplicate the primary key.\n  please try again...\n"
						sleep 1

					fi 
				fi

				if [[ $newColumn != +([a-zA-Z]) ]]
				then
				echo "9"
					echo -e "\n* Please, Enter STRING .\n"
					sleep 1
				
				else
				echo "1"
					oldColumn=`awk -F: '{if (NR=="'$row_num'") print $0}' $path/$table_name | cut -d: -f$i`
					echo "oldColumn $oldColumn"
					sed -i ''$row_num's/'$oldColumn'/'$newColumn'/g' $path/$table_name
					((i++))
					((flag=0))
				fi


			fi
		fi

	done

	

}


UpdateRecord
# UbdateColumn











