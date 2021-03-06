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


((i=1))
((flag=1))
recordData=""
sep=":"
function InsertData
{
    
    cols_num=$(awk -F: '{if(NR==1) print NF}' $path/$table_name) #number of columns in table col+1 (:)

    while [[ $i < $cols_num ]]
    do

        col_name=$(awk -F: '{if(NR==1) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) # get name of column from line 1 each loop
        col_type=$(awk -F: '{if(NR==2) for ( i=1; i<2; i++ ) print $'$i'}' $path/$table_name) # get type of column from line 2 each loop


        read -p "~> Please Enter $col_name [$col_type]: " value
        

        # Check The values if Integer.
        if [[ $col_type = "int" ]]
        then
        
            if [[ $flag -eq 1 ]]
            then
                Pcheck=`awk -F: '{if ($1 == "'$value'" && NR>2 ) print 1}' $path/$table_name`  # this line check if PK is exist (will print 1)
                if  [[ $Pcheck == "1" ]]
                then
                    echo -e "* Sorry, you can't duplicate the primary key.\n  please try again...\n"
                    
                    sleep 1
                    continue
                fi
            fi

            if [[ $value != +([0-9]) ]]
            then
                echo -e "\n* Please, Enter INETGER number....\n"

                sleep 1
                continue

            else
                recordData+=$value$sep
                ((i++))
                ((flag=0))
            fi
        fi

        # Check The values if String.
        if [[ $col_type = "str" ]]
        then

            if [[ $flag -eq 1 ]]
            then
                Pcheck=`awk -F: '{if ($1 == "'$value'" && NR>2 ) print 1}' $path/$table_name`  # this line check if PK is exist (will print 1)
                
                if  [[ $Pcheck -eq 1 ]]
                then
                    echo -e "* Sorry, you can't duplicate the primary key.\n  please try again...\n"
                    sleep 1

                fi 
            fi

            if [[ $value != +([a-zA-Z_@.]) ]]
            then
                echo -e "\n* Please, Enter STRING .\n"
                sleep 1
            
            else
                recordData+=$value$sep
                ((i++))
                ((flag=0))
            fi
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
