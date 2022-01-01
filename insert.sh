#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name

function Insert
{
    echo -e "\n~> Enter Table name: "
    read table_name


    if [ ! -f $path/$table_name ]
    then
        echo "\n** Table ($table_name) is not Exist.\nPlease try again... \n"
        Insert
    else
        typeset -i index
        index=0
        while [[ $index -lt $col_num ]]
        do
            awk -F: '{if(NR==1) for ( i=1; i<NF; i++) print $i}' $path/$table_name    
        done
        
        

        
    fi
}

Insert