#!/bin/bash
if [ $1 == "list" ]
then
	num=0 
	for count in `ls databases/$currentDb | grep -v Schema 2>>./.error.log`
	do
		((num=num+1))
		echo "$num- $count"
	done
	./redisplayMenus.sh 2
	exit
elif [ $1 == "call" ]
then 
	tableExist=0
    # Check table existance
	for count in `ls databases/$currentDb | grep -v Schema 2>>./.error.log`
	do
		if [ $2 == $count ]
		then
			tableExist=1
		fi
	done			
fi
