#!/bin/bash
shopt -s extglob

path=./my_dbms/$select_name

function createTable
{
echo -e "\nEnter Table name: "
read table_name

case $table_name in
	+([a-zA-Z])) # work by using [shopt -s extglob] lib
		if [ ! -f $path/$table_name ]
		then
			touch ./my_dbms/$select_name/$table_name;
			MetaData
			echo -e 'Table Created Successfully.\n'
			sleep 1
			. ./use_db.sh
		else 
			echo "Table ($table_name) is Exist."
			sleep 1
			createTable
		fi
			;;
	*) echo -e "\nTable name can not contain number or spesial characters.\nplease, Try again..."
	   createTable ;;
esac
}

function MetaData
{
	echo -e '\nEnter Number of Columns: '
	read col_num
	case  $col_num in
		+([1-9]))
			typeset -i index
	                index=0
			let nu=index+1
			flag="0"
			metaData=""
			column_type=""
			ColumnTypeLine=""
			sep="|"
			newLine="\n"

			while [[ $index -lt $col_num ]]
			do
				if [[ $flag=="0" ]]
				then
					echo -e "\nEnter Primary Key column $nu:"
					read col_name
					$flag="1"
				else
					echo -e "\nEnter column $nu:"
                                        read col_name
				fi
				echo -e "\nEnter Column data type \n1] Int \n2] Str"
                                        read col_type
                                        case $col_type in
                                                1) column_type="int";;
                                                2) column_type="str";;
                                                *) echo "Wrong Choise..";;
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
			echo "You must enter number.."
			MetaData
			;;
	esac
}


createTable
