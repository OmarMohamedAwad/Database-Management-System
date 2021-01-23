#!/bin/bash
typeset columnArray[2]
function checkColumn
{
        repeatFlag=0
        for i in columnArray[*]
        do
                if [ $i = $1 ]
                then
                        repeatFlag=1
                        break
                fi
        done
        source ./dataType.sh "check" $2 #dataTypeIsExist
}
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
                checkColumn $column $dataType
                if [ repeatFlag -eq 1 ]
                then
                        echo "Duplicate column name $column"
		elif [ dataTypeIsExist -eq 0 ]
                then
                        echo "Datatype dose not exist"
                else
                       columnArray[index]=$column
                       echo $column:$dataType, >> databases/$currentDb/${tableName}_Schema
                       echo $column:$dataType, >> databases/$currentDb/Schema
                       (( index+=1 ))
                fi
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
                echo $tableName, >> databases/$currentDb/${tableName}_Schema
                echo $tableName, >> databases/$currentDb/Schema


                echo "Table $tableName Successfully Created"
		insertCoulmn
                exit
        else
                echo "Table Already Exsits"
                exit
        fi
}

createTable



