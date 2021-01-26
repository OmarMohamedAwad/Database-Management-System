#!/bin/bash

function updateTable
{
	fieldLoopCounter=`awk -F, '{ print NF }' databases/$currentDb/${tbName}_Schema `
	typeset fieldsArray[2]
	((fieldCounter=1))
	((arrayCounter=0))
	for ((j=0;j<"$fieldLoopCounter";j++));do
		i=`cat databases/$currentDb/${tbName}_Schema | cut -f$fieldCounter -d,`
		fieldsArray[$arrayCounter]=$i
		((arrayCounter=arrayCounter+1))
		((fieldCounter=fieldCounter+1))
	done
	((fieldCounter-=2))
	# echo $fieldCounter
	temp=${fieldsArray[fieldCounter]}
	fieldsArray[$fieldCounter]="$1"
	((fieldCounter+=1))
	fieldsArray[$fieldCounter]="$2"
	((fieldCounter+=1))
	fieldsArray[$fieldCounter]="$temp"
	echo ${fieldsArray[*]}
}

function checkColumn
{
	echo -e "Enter Column Name: \c"
	read columnName
	echo -e "Enter Column Data Type: \c"
	read columnDataType
	source ./dataType.sh "check" $columnDataType

	column=$(awk 'BEGIN{FS=","}{for(i=1;i<=NF;i++){if($i=="'$columnName'") print $i}}' databases/$currentDb/${tbName}_Schema)
	
	if [[ $column = "" && -n $columnName ]]
	then
		if [ $dataTypeIsExist -eq 0 ]
		then
				echo "Datatype dose not exist"
		else
			updateTable $columnName $columnDataType
		fi
	else
		echo "Invalid Column"
		checkColumn
	fi
}

function update
{
	echo -e "Enter Table Name: \c"
	read tbName

	#Check if table exists
	source ./listTables.sh "call" $tbName

	if [ $tableExist -eq 0 ]
	then
		echo "There is no table by this name"
		exit
	else
		select choice in "Update Table" "Update Rows" "Exit"
		do
			case $REPLY in
				1) 
					checkColumn
					exit
				;;
				2)
					updateRow
					exit
				;;
				3)
					exit
				;;				
				*) echo "invaled option"
				;;
			esac
		done 
        
		exit
	fi
}

update
