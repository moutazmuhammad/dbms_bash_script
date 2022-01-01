#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name

function Insert
{
    echo -e "\n~> Enter Table name: "
    read table_name

    case $table_name in
        +([a-zA-Z]))
            if [ ! -f $path/$table_name ]
            then
                echo "\n** Table ($table_name) is not Exist.\nPlease try again... \n"
                Insert
            else 
                
            fi
            ;;
        *) echo -e "\n** There is no Table name contain number or spesial characters.\nplease, Try again..."
            Insert ;;
    esac
}