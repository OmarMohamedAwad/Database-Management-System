#!/bin/bash
if [ $1 == "list" ]
then
	num=0 
    	for count in `ls databases/$currentDb | grep -v Schema`
    	do
		((num=num+1))
        	echo "$num- $count"
    	done
elif [ $1 == "call" ]
then 
	tableExist=0
    	#echo "check table existance"
	for count in `ls databases/$currentDb | grep -v Schema`
	do
		if [ $2 == $count ]
		then
			tableExist=1
			
		fi
	done	
	#echo $tableExist
		
fi
