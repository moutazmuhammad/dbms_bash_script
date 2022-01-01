#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name

function createTable
{
echo -e "\n~> Enter Table name: "
read table_name

case $table_name in
	+([a-zA-Z])) # work by using [shopt -s extglob] lib
		if [ ! -f $path/$table_name ]
		then
			touch ./my_dbms/$select_name/$table_name;
			MetaData
			echo -e '** Table Created Successfully.\n'
			sleep 1
			. ./use_db.sh
		else 
			echo "** Table ($table_name) is Exist."
			sleep 1
			createTable
		fi
			;;
	*) echo -e "\n** Table name can not contain number or spesial characters.\nplease, Try again..."
	   createTable ;;
esac
}

function MetaData
{
	echo -e '\n~> Enter Number of Columns: '
	read col_num
	case  $col_num in
		+([1-9]))
			typeset -i index
	                index=0
			let nu=index+1
			((flag=0))
			metaData=""
			column_type=""
			ColumnTypeLine=""
			sep="|"
			newLine="\n"

			while [[ $index -lt $col_num ]]
			do
				if [[ $flag -eq 0 ]]
				then
					echo -e "\n~> Enter Primary Key column $nu:"
					read col_name
					if [[ $col_name == +([a-zA-Z]) ]]
					then
						((flag=1))
					else
						echo -e "** Column name must be string.\nYou will enter table metadata from begining ..."
						MetaData
					fi
				else
					echo -e "\n~> Enter column $nu:"
                                        read col_name
					if [[ $col_name != +([a-zA-Z]) ]]
                                        then
                                                echo -e "** Column name must be string.\nYou will enter table metadata from begining ..."
						MetaData
                                        fi
				fi
				echo -e "\n~> Enter Column data type: \n1] Int \n2] Str"
                                        read col_type
                                        case $col_type in
                                                1) column_type="int";;
                                                2) column_type="str";;
                                                *) echo -e "Wrong Choise..\nYou will enter table metadata from begining ... "; 
						   ((flag=0));
						   MetaData;;
                                        esac
				((index++))
				((nu++))
				metaData+=$sep$col_name$sep
				ColumnTypeLine+=$sep$column_type$sep
			done
			echo $metaData >> ./my_dbms/$select_name/$table_name
			echo $ColumnTypeLine >> ./my_dbms/$select_name/$table_name
			;;
		*)
			echo "** You must enter number.."
			MetaData
			;;
	esac
}


createTable
