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
		./redisplayMenus.sh 2
		exit
	else
		source ./listTables.sh "call" $tbName
	fi

	if [ $tableExist -eq 0 ]
	then
		echo "There is no table by this name"
		./redisplayMenus.sh 2
		exit
	else 
		rm  databases/$currentDb/$tbName 2>>./.error.log
		rm  databases/$currentDb/${tbName}_Schema 2>>./.error.log
		sed -i "/$tbName,/d" "databases/$currentDb/Schema" 
		echo "Table $tbName Deleted Correctly"
		./redisplayMenus.sh 2
		exit
	fi
}

dropTable
