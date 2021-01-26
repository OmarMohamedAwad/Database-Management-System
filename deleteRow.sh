#!/bin/bash

function checkCoulmnValue 
{
	echo -e "Enter Column Value: \c"
	read columnValue
	typeset arrayRows[2]
	index=0

	columnVal=`awk 'BEGIN{FS=","}{for(i=1;i<=NF;i++){if($i=="'$columnName'"){j=i+1; if($j == "'$columnValue'"){print NR}}}}' databases/$currentDb/$tbName`
	for i in $columnVal
	do
		arrayRows[$index]=$i
		(( index+=1 ))
	done

	(( index=1 ))
	line=""
	for i in ${arrayRows[*]}
	do
		if [ $index -eq ${#arrayRows[*]} ]
		then
			line+="${i}d" 
		else
			line+="${i}d;"
		fi
		(( index+=1 ))
	done
	`sed -i $line databases/$currentDb/$tbName`
}

function checkColumn
{
        echo -e "Enter Column Name: \c"
		read columnName

		column=$(awk 'BEGIN{FS=","}{for(i=1;i<=NF;i++){if($i=="'$columnName'") print $i}}' databases/$currentDb/${tbName}_Schema)
		if [[ $column = "" ]]
		then
			echo "Invalid Column"
			checkColumn
		else
			checkCoulmnValue
			echo "All data have this value are deleted"
		fi
}

function deleteRow
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
		select choice in "Delete All Data" "Delete Special Rows" "Exit"
		do
			case $REPLY in
				1) 
					`sed -i '1,$d' databases/$currentDb/$tbName`
					echo "All $tbName Rows Are Deleted"
					exit
				;;
				2)
					checkColumn
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

deleteRow
