#!/bin/bash
path=./my_dbms/$select_name

# Check if table exist or not
echo -e "\n** Enter Table name: "
    read -p "~> " table_name

if [ ! -f $path/$table_name ]
then
    echo -e "\n* Table ($table_name) is not Exist.\nPlease try again... \n"
    sleep 1
    . ./use_db.sh
fi


function DeleteFromTable {
       echo -e "\n** Enter Primary key: "
       read -p "~> " Pkey
       Pcheck=`awk -F: '{if ($1 == "'$Pkey'") print 1}' $path/$table_name` # this line check if PK is exist (will print 1)
       if  [[ $Pcheck -eq 1 ]]
        then
            row_Del=`awk -F: '{if ($1 == "'$Pkey'"){print NR}}' $path/$table_name` # this line get number of line with primary key $Pkey
            sed -i ''$row_Del'd' $path/$table_name
            echo -e "* Data with Primary key $Pkey deleted succefully....\n"
            sleep 1
        else
		echo "* NO available data!"
        sleep 1
	fi

}
DeleteFromTable
. ./use_db.sh
             