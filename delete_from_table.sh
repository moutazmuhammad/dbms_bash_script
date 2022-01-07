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

# Check if table exist or not
echo -e "\n** Enter Table name: "
    read -p "~> " table_name

if [ ! -f $path/$table_name ]
then
    echo -e "\n* Table ($table_name) is not Exist.\n  Please try again... \n"
    sleep 1
    . ./delete_from_table.sh
fi

# Check number of PK in table 
num_of_PK=`cat $path/$table_name | wc -l`
echo "num_of_PK $num_of_PK"
if  [[ $num_of_PK -eq 2 ]]
then
	echo -e "\n* There is no record in this table yet!"
	sleep 1
	. ./use_db.sh
fi

function Delete_Menu
{
	clear
	echo -e "\n\n            o<><><><><><><><><><><><><><><><>o"
	echo "            |                                |"
	echo "            |  1 -> Delete All Records       |"
	echo "            |  2 -> Delete Specific Record   |"
	echo "            |  3 -> Return to previous menu  |"
	echo "            |                                |"
    echo -e "            o<><><><><><><><><><><><><><><><>o\n"

	read -p "~> Please, Enter a number: " num

	case $num in
		1) DeleteAllRecords ;;
		2) DeleteFromTable;;	
		3) . ./use_db.sh ;;
		*) echo "* Wrong Choise! please Enter Correct Number..."; sleep 1; clear; SelectMenu;;
	esac
}


function DeleteFromTable {
       echo -e "\n** Enter Primary key: "
       read -p "~> " Pkey
       Pcheck=`awk -F: '{if ($1 == "'$Pkey'" && NR<=2) print 1}' $path/$table_name` # this line check if PK is exist (will print 1)

       if  [[ $Pcheck -eq 1 ]]
        then

            check_row_num=`awk -F: '{if ("'$Pkey'"==$1 && NR<=2) print 1}' $path/$table_name`
            if [[ $check_row_num -ne 1 ]] # check that the value entered by use != metadata
            then
                row_Del=`awk -F: '{if ($1 == "'$Pkey'"){print NR}}' $path/$table_name` # this line get number of line with primary key $Pkey
                sed -i ''$row_Del'd' $path/$table_name
                echo -e "* Data with Primary key $Pkey deleted succefully....\n"
                sleep 1
                Delete_Menu
                else
                    echo "* Not allow to delete Metadata!"
                    sleep 1
                    DeleteFromTable
            fi

        else
		echo "* NO available data!"
        sleep 1
        DeleteFromTable

	fi

}
function DeleteAllRecords
{
	sed -i '3,$ d' $path/$table_name
    echo "* All Records Deleted Successfully. "
    sleep 1
  
  
    Delete_Menu
}

Delete_Menu

