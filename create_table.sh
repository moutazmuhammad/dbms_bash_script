#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name
PS3='~> '

function createTable
{
	echo -e "\n** Enter Table name: "
	read -p "~> " table_name

	if [[ $table_name == +([a-zA-Z]) ]]  # work by using [shopt -s extglob] lib
	then
			if [ ! -f $path/$table_name ]
			then
				touch ./my_dbms/$select_name/$table_name;
				MetaData
				echo -e '* Table Created Successfully.\n'
				sleep 1
				. ./use_db.sh
			else 
				echo "* Table ($table_name) is Exist."
				sleep 1
				createTable
			fi
	else
			echo -e "\n* Table name can not contain number or special characters.\n  please, Try again..."
			createTable ;
	fi
}


all_columns="" # has all names of columns that the user enter.
col_name=""

function checkColumnExist # this function dose not allow to duplicate column name
{
	numb=`echo "$all_columns" | awk -F: '{print NF}'` 

	for ((i=1 ; i<$numb ; i++))
	do
		checker=`echo $all_columns | cut -d: -f$i`
		while [[ $checker == $col_name ]]
		do
			echo -e "\n* You Can not Duplicate Column Name.\n  Please, Enter New Column Name:"
			read -p "~> " col_name
			
		done
	done
}


((flag=1)) # for pk
metaData=""
column_type=""
ColumnTypeLine=""
function MetaData
{
	sep=":"

	((i=0))
	((counter=1))

	echo -e '\n** Enter Number of Columns: '
	read -p "~> " col_num

	((col_num++))
	if [[ $col_num == +([1-9]) ]]
	then

		while [[ i -lt $col_num ]]
		do

			if [[ $flag -eq 1 ]]
			then
				echo -e "\n** Enter Primary Key column [$counter]:"
				read -p "~> " col_name
				all_columns+=$col_name$sep

				if [[ $col_name == +([a-zA-Z]) ]]
				then
					select col_type in "Integer" "string"
					do
						case $col_type in
								"Integer") column_type="int"; break;;
								"string") column_type="str"; break;;
								*) echo -e "Wrong Choise..\n "; 
						esac
					done
					metaData+=$col_name$sep
					ColumnTypeLine+=$column_type$sep
					((i++))
					((counter++))
					((flag=0))
				else
					echo -e "* Column name must be string.\n"
					continue
				fi

			else

				if [[ $col_name == +([a-zA-Z]) ]]
				then
					echo -e "\n** Enter column [$counter]:"
					read -p "~> " col_name

					checkColumnExist

					all_columns+=$col_name$sep

					if [[ $col_name != +([a-zA-Z]) ]]
					then
						echo -e "* Column name must be string.\n"
						continue
					else

						select col_type in "Integer" "string"
						do
							case $col_type in
									"Integer") column_type="int"; break;;
									"string") column_type="str"; break;;
									*) echo -e "Wrong Choise..\n";
							esac
						done
						metaData+=$col_name$sep
						ColumnTypeLine+=$column_type$sep

						((i++))
						((counter++))

					fi
				fi

			fi

		done

		

	else
		MetaData
	fi

	echo $metaData >> ./my_dbms/$select_name/$table_name
	echo $ColumnTypeLine >> ./my_dbms/$select_name/$table_name

}


createTable
