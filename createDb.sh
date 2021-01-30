#!/bin/bash

function createDB
{
	echo -e "Enter Unique Database Name: \c"
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
		#create Database directory and Schema
       	mkdir databases/$dbName 2>>./.error.log
        touch databases/$dbName/Schema 2>>./.error.log

		echo "DataBase $dbName Successfully Created"
		exit
	else 
		echo "DataBase Already Exsits"
		exit
	fi

}

createDB

