#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name

echo -e "\n** Enter Table name: "
    read -p "~> " table_name

if [ ! -f $path/$table_name ]
then
    echo -e "\n* Table ($table_name) is not Exist.\nPlease try again... \n"
    sleep 1
    . ./insert.sh
fi

function InsertData
{
    cols_num=`awk -F: '{if(NR==1) print NF}' $path/$table_name` #number of columns in table col+1
    
    for (( i = 1; i < $cols_num; i++ ))
    do

        col_name=$(awk -F: '{if(NR==1) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) #get name of column from line 1
        col_type=$(awk -F: '{if(NR==2) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) #get type of column from line 2
        read -p "~> Please Enter $col_name [$col_type]: " value

        # Check The values if integer or string.
        if [[ $col_type == 'int' ]]
        then

            while [[ $value != +([0-9]) ]]
            do
                echo -e "\n* Please, Enter INETGER number.\nYou will enter the data of record from beginning...\n"
                sleep 1
                InsertData
            done

        elif [[ $col_type == 'str' ]]
        then

            while [[ $value != +([a-zA-Z]) ]]
            do
                echo -e "\n* Please, Enter STRING .\nYou will enter the data of record from beginning...\n"
                sleep 1
                InsertData
            done

        fi


    done       
}

InsertData