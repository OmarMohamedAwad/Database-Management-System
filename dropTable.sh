#!/bin/bash

# Drop Table
function dropTable
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
		rm  databases/$currentDb/$tbName 2>>./.error.log
		rm  databases/$currentDb/${tbName}_Schema 2>>./.error.log
		echo "Table $tbName Deleted Correctly"
		exit
	fi
}

dropTable
