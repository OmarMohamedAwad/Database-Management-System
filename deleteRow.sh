#!/bin/bash

function checkColumn
{
        echo -e "Enter Column Name: \c"
		read columnName
		#Chenge it when merge |
		column=`cut -f2- -d, databases/$currentDb/${tbName}_Schema | grep ,$columnName,`
		if [ -z $column ]
		then
			echo "Invalid Column"
			checkColumn
		else
			echo -e "Enter Column Value: \c"
			read columnValue
			`sed -i '/',$columnName,$columnValue,'/d' databases/$currentDb/$tbName`
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
