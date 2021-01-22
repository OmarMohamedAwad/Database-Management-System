#!/bin/bash

function selectDB
{
	echo -e "Enter Database Name: \c"
	read dbName

	#Check if database exists
	source ./listDb.sh "call" $dbName

	if [ $dbExist -eq 0 ]
	then
		echo "There are no database have this name"
		exit
	else
		cd . database/$dbName 2>>./.error.log 
		echo "Database $dbName was Successfully Selected"
		#table menue
	fi

}

selectDB
