#!/bin/bash

# Display table meta data
function metaData
{
	echo -e "Enter Table Name: \c"
	read tbName

	#Check if table exists
	if [ -z $tbName ]
	then
		echo "You Must Enter Valid Name"
		exit
	else
		source ./listTables.sh "call" $tbName
	fi

	if [ $tableExist -eq 0 ]
	then
		echo "There is no table by this name"
		exit
	else
		fieldLoopCounter=`awk -F, '{ print NF }' databases/$currentDb/${tbName}_Schema 2>>./.error.log`
		typeset fieldsArray[2]
		((fieldCounter=1))
		((arrayCounter=0))
		for ((j=0;j<"$fieldLoopCounter";j++));do
			i=`cat databases/$currentDb/${tbName}_Schema | cut -f$fieldCounter -d, 2>>./.error.log`
			fieldsArray[$arrayCounter]=$i
			((arrayCounter+=1))
			((fieldCounter+=1))
		done
		((fieldCounter-=2))
		temp=${fieldsArray[fieldCounter]}
		fieldsArray[$fieldCounter]="primary key"
		((fieldCounter+=1))
		fieldsArray[$fieldCounter]="$temp"
		
		for ((i=0;i<="$fieldCounter";i++))
		do
			if [ $i -eq $fieldCounter ]
			then
				echo ": ${fieldsArray[i]}"
			else
				if [[ ${fieldsArray[$i]} = 'int' || ${fieldsArray[$i]} = 'varchar' || ${fieldsArray[$i]} = 'string' ]]
				then
					echo -e " : ${fieldsArray[i]} | \c"
				else
					echo -e "${fieldsArray[i]}\c"
				fi
			fi
		done        
	fi
}

metaData