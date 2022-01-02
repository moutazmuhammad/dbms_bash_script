#!/bin/bash
path=./my_dbms/$select_name

echo -e "\n** Enter Table name: "
    read -p "~> " table_name

if [ ! -f $path/$table_name ]
then
    echo -e "\n* Table ($table_name) is not Exist.\nPlease try again... \n"
    sleep 1
    . ./use_db.sh
fi

function DeleteFromTable {
       echo -p "\n** Enter Primary key: "
       read Pkey
       Pcheck=`awk '{if($1 = $Pkey) print 1}' $path/$table_name`
       echo $Pcheck
       #`awk -F: 'BEGIN{res=1}{if ($1='$Pkey')} END{print res}' $path/$table_name`
       #Pcheck = `awk -F: '{ res = 1 }{if ($1 = '$Pkey')} END{print res}' $path/$table_name`
       if  [[ $Pcheck -eq 1 ]]
          then
           row_Del=`awk -F: '{if ($1 = '$Pkey'){print NR}}' $path/$table_name`
                sed -i ''$row_Del'd' $path/$table_name
                echo "Data with Primary key $Pkey deleted succefully!"
        else
		echo "NO available data!"

	fi

}
DeleteFromTable             

             