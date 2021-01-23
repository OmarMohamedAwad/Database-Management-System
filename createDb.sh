#!/bin/bash

function createDB
{
	echo -e "Enter Unique Database Name: \c"
	read dbName

	#Check if database exists
	source ./listDb.sh "call" $dbName

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

