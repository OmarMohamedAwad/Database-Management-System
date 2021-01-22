#!/bin/bash

function dropDB
{
	echo "Please enter the database name you need to drop"
	read dbName

	#Check if database exists
	source ./listDb.sh "call" $dbName

	if [ $dbExist -eq 0 ]
	then
		echo "There are no database have this name"
		exit
	else 
		rm -r databases/$dbName
		echo "DataBase Deleted Correctly"
		exit
	fi

}

dropDB
