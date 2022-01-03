#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name
PS3='~> '
function createTable
{
	echo -e "\n** Enter Table name: "
	read -p "~> " table_name

	case $table_name in
		+([a-zA-Z])) # work by using [shopt -s extglob] lib
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
				;;
		*) echo -e "\n* Table name can not contain number or spesial characters.\nplease, Try again..."
		createTable ;;
	esac
}

function MetaData
{
	echo -e '\n** Enter Number of Columns: '
	read -p "~> " col_num
	export col_num
	case  $col_num in
		+([1-9]))
			typeset -i index
	                index=0
			let i=index
			let nu=index+1
			((flag=0))
			metaData=""
			column_type=""
			ColumnTypeLine=""
			sep=":"
			newLine="\n"

			while [[ $index -lt $col_num ]]
			do

				if [[ $flag -eq 0 ]]
				then
					echo -e "\n** Enter Primary Key column $nu:"
					read -p "~> " col_name
					arr[$i]=$col_name
					((i++))
					if [[ $col_name == +([a-zA-Z]) ]]
					then
						((flag=1))
					else
						echo -e "* Column name must be string.\nYou will enter table metadata from beginning ..."
						MetaData
					fi
				else
					echo -e "\n** Enter column $nu:"
                    read -p "~> " col_name
					arr[$i]=$col_name
					((i++))
					if [[ $col_name != +([a-zA-Z]) ]]
					then
						echo -e "* Column name must be string.\nYou will enter table metadata from beginning ..."
						MetaData
                    fi
				fi

		
				select col_type in "Integer" "string"
				do

					case $col_type in
							"Integer") column_type="int"; break;;
							"string") column_type="str"; break;;
							*) echo -e "Wrong Choise..\nYou will enter table metadata from begining ... "; 
							((flag=0));
					esac

				done

				
				metaData+=$col_name$sep
				ColumnTypeLine+=$column_type$sep

				((index++))
				((nu++))

			done

			echo $metaData >> ./my_dbms/$select_name/$table_name
			echo $ColumnTypeLine >> ./my_dbms/$select_name/$table_name
			;;
		*)
			echo "* You must enter number.."
			MetaData
			;;
	esac
}


createTable
