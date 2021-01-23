#!/bin/bash

function dropTable
{
	echo -e "Enter Table Name: \c"
	read tblName

	#Check if table exists
	source ./listTable.sh "call" $tblName

	if [ $tableExist -eq 0 ]
	then
		echo "There is no table by this name"
		exit
	else 
		rm  databases/$currentDb/$tblName
		rm  databases/$currentDb/${tblName}_schema
		echo "Table $tblName Deleted Correctly"
		exit
	fi
}

dropTable
