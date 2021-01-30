#!/bin/bash

function selectDB
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
		currentDb=$dbName 
		#cd databases/$dbName 2>>./.error.log 
		echo "Database $dbName was Successfully Selected"
		export currentDb
		./tableMenu.sh
	fi

}

selectDB
