#!/bin/bash
if [ $1 == "list" ]
then
	num=0 
    	for count in `ls databases`
    	do
		((num=num+1))
        	echo "$num- $count"
    	done
    	./main.sh
elif [ $1 == "call" ]
then 
    	echo "check database existance"
	for count in `ls databases`
	do
		if [ $2 == $count ]
		then
			dbExist=1
			echo $dbExist
			exit
		fi
	done	
	dbExist=0
	echo $dbExist
		
fi
