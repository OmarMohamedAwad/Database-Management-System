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
		rm  databases/$1/$tblName
		rm  databases/$1/${tblName}_schema
		echo "Table $tblName Deleted Correctly"
		exit
	fi
}

dropTable
