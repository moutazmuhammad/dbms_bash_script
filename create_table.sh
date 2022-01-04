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
			echo -e "\n* Table name can not contain number or spesial characters.\nplease, Try again..."
			createTable ;
	fi
}

((flag=1))

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

	if [[ $col_num == +([1-9]) ]]
	then

		while [[ i -lt $col_num ]]
		do

			if [[ $flag -eq 1 ]]
			then
				echo -e "\n** Enter Primary Key column [$counter]:"
				read -p "~> " col_name

				if [[ $col_name == +([a-zA-Z]) ]]
				then
					select col_type in "Integer" "string"
					do
						case $col_type in
								"Integer") column_type="int"; break;;
								"string") column_type="str"; break;;
								*) echo -e "Wrong Choise..\n  You will enter table metadata from begining ... "; 
						esac
					done
					metaData+=$col_name$sep
					ColumnTypeLine+=$column_type$sep
					((i++))
					((counter++))
					((flag=0))
				else
					echo -e "* Column name must be string.\n  You will enter table metadata from beginning ..."
					continue
				fi

			else

				if [[ $col_name == +([a-zA-Z]) ]]
				then
					echo -e "\n** Enter column [$counter]:"
					read -p "~> " col_name

					if [[ $col_name != +([a-zA-Z]) ]]
					then
						echo -e "* Column name must be string.\n  You will enter table metadata from beginning ..."
						continue
					else

						select col_type in "Integer" "string"
						do
							case $col_type in
									"Integer") column_type="int"; break;;
									"string") column_type="str"; break;;
									*) echo -e "Wrong Choise..\n  You will enter table metadata from begining ... ";
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
