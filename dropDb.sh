#!/bin/bash

function dropDB
{
	echo -e "Enter Database Name: \c"
	read dbName

	#Check if database exists
	if [ -z $dbName ]
	then
		echo "You Must Enter Valid Name"
		exit
	else 
		source ./listDb.sh "call" $dbName
	fi

	if [ $dbExist -eq 0 ]
	then
		echo "There are no database have this name"
		exit
	else 
		rm -r databases/$dbName 2>>./.error.log
		echo "DataBase $dbName Deleted Correctly"
		exit
	fi

}

dropDB
