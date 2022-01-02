#!/bin/bash
shopt -s extglob

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


function InsertData
{
    ((flag=1))
    export recordData=""
    sep=":"
    cols_num=`awk -F: '{if(NR==1) print NF}' $path/$table_name` #number of columns in table col+1
    
    for (( i = 1; i < $cols_num; i++ ))
    do

        col_name=$(awk -F: '{if(NR==1) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) #get name of column from line 1
        col_type=$(awk -F: '{if(NR==2) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) #get type of column from line 2
        pk_col=$(awk -F: '{if(NR==3) print $1}' $path/$table_name) #get pk from line 3
        read -p "~> Please Enter $col_name [$col_type]: " value

        # Check The values if integer or string.
        if [[ $col_type == 'int' ]]
        then

            while [[ $value != +([0-9]) ]]
            do
                echo -e "\n* Please, Enter INETGER number.\n  You will enter the data of record from beginning...\n"
                sleep 1
                InsertData
            done

        elif [[ $col_type == 'str' ]]
        then

            while [[ $value != +([a-zA-Z]) ]]
            do
                echo -e "\n* Please, Enter STRING .\n  You will enter the data of record from beginning...\n"
                sleep 1
                
                InsertData
            done

        fi

        # Check if value is primary key or not.

        Pcheck=`awk -F: '{if ($1 == "'$value'") print 1}' $path/$table_name`  # this line check if PK is exist (will print 1)
        if  [[ $Pcheck -eq 1 ]]
        then
            echo -e "* You Sorry, you can't duplicate the primary key.\n  please try again...\n"
            sleep 1
            InsertData
        else
            recordData+=$value$sep
        fi

    done

}

# this function dose not allow to duplicate lines by 'echo' like "END"
function echoData
{
    InsertData
    echo $recordData >> ./my_dbms/$select_name/$table_name
    echo -e "\n* Record Added succefully...\n"
    sleep 1
    . ./use_db.sh
}
echoData

