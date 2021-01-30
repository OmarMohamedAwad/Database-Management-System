#!/bin/bash
if [ $1 == "list" ]
then
	num=0 
    	for count in `ls databases`
    	do
		((num=num+1))
        	echo "$num- $count"
    	done
elif [ $1 == "call" ]
then 
	dbExist=0
    	#echo "check database existance"
	for count in `ls databases`
	do
		if [ $2 = $count ]
		then
			dbExist=1
			#echo $dbExist
			
		fi
	done	
	#echo $dbExist
		
fi
