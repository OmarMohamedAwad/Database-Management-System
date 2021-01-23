#!/bin/bash

#Insert Column
function insertCoulmn
{
	echo -e "Number of columns:\c"
	read columnsNumber
	index=0
	while ((index<columnsNumber))
	do
		echo -e "Enter Column ${index+1}:\c"
		read column
		echo -e "Enter DataType:\c"
		read dataType
		
		(( index+=1 ))
	done

}

#Create Table
function createTable
{
        echo -e "Enter Unique Table Name: \c"
        read tableName

        #Check if table exists
        source ./listTables.sh "call" $tableName

        if [ $tableExist -eq 0 ]
        then
                #create Table directory and Schema
                touch databases/$currentDb/$tableName 2>>./.error.log
                touch databases/$currentDb/${tableName}_Schema 2>>./.error.log

                echo "Table $tableName Successfully Created"
		insertCoulmn
                exit
        else
                echo "Table Already Exsits"
                exit
        fi

}

createTable



