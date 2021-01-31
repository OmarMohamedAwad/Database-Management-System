#!/bin/bash

# List Databases
if [ $1 == "list" ]
then
	num=0 
	for count in `ls databases 2>>./.error.log`
	do
		((num=num+1))
		echo "$num- $count"
	done
	./redisplayMenus.sh 1
	exit

# Check if Database exist
elif [ $1 == "call" ]
then 
	dbExist=0
	for count in `ls databases`
	do
		if [ $2 = $count ]
		then
			dbExist=1
		fi
	done	
		
fi
