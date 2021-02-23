#!/bin/bash

# Drop Database
function dropDB
{
	echo -e "Enter Database Name: \c"
	read dbName

	#Check if database exists
	if [ -z $dbName ]
	then
		echo "You Must Enter Valid Name"
		./redisplayMenus.sh 1
		exit
	else 
		source ./listDb.sh "call" $dbName
	fi

	if [ $dbExist -eq 0 ]
	then
		echo "There is no database has this name"
		./redisplayMenus.sh 1
		exit
	else 
		rm -r databases/$dbName 2>>./.error.log
		echo "DataBase $dbName Deleted Correctly"
		./redisplayMenus.sh 1
		exit
	fi

}

dropDB
