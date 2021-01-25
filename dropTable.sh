#!/bin/bash

function dropTable
{
	echo -e "Enter Table Name: \c"
	read tblName
	if [ $tblName = ""]
	then
		echo "No table name entered"
		exit
	fi
	#Check if table exists
	source ./listTables.sh "call" $tblName

	if [ $tableExist -eq 0 ]
	then
		echo "There is no table by this name"
		exit
	else 
		rm  databases/$currentDb/$tblName
		rm  databases/$currentDb/${tblName}_Schema
		echo "Table $tblName Deleted Correctly"
		exit
	fi
}

dropTable
