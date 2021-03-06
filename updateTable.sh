#!/bin/bash

# Update table
function update
{
	echo -e "Enter Table Name: \c"
	read tbName

	#Check if table exists
	if [ -z $tbName ]
	then
		echo "You Must Enter Valid Name"
		./redisplayMenus.sh 2
		exit
	else
		source ./listTables.sh "call" $tbName
	fi

	if [ $tableExist -eq 0 ]
	then
		echo "There is no table by this name"
		./redisplayMenus.sh 2
		exit
	else
		select choice in "Update Table" "Update Rows" "Exit"
		do
			case $REPLY in
				1) 
					checkColumn
					./redisplayMenus.sh 2
		            exit
				;;
				2)
					updateRowData
					./redisplayMenus.sh 2
		            exit
				;;
				3)
					./redisplayMenus.sh 2
		            exit
				;;				
				*) echo "invaled option"
				;;
			esac
		done         
	fi
}

# Check column
function checkColumn
{
	echo -e "Enter Column Name: \c"
	read columnName
	echo -e "Enter Column Data Type: \c"
	read columnDataType
	source ./dataType.sh "check" $columnDataType

	column=$(awk 'BEGIN{FS=","}{for(i=1;i<=NF;i++){if($i=="'$columnName'") print $i}}' databases/$currentDb/${tbName}_Schema 2>>./.error.log)
	
	if [[ $column = "" && -n $columnName ]]
	then
		if [ $dataTypeIsExist -eq 0 ]
		then
				echo "Datatype dose not exist"
		else
			updateTable $columnName $columnDataType
		fi
	else
		echo "Column Already Exist"
		checkColumn
	fi
}

# Update Table Structure
function updateTable
{
	fieldLoopCounter=`awk -F, '{ print NF }' databases/$currentDb/${tbName}_Schema 2>>./.error.log`
	typeset fieldsArray[2]
	((fieldCounter=1))
	((arrayCounter=0))
	for ((j=0;j<"$fieldLoopCounter";j++));do
		i=`cat databases/$currentDb/${tbName}_Schema | cut -f$fieldCounter -d, 2>>./.error.log`
		fieldsArray[$arrayCounter]=$i
		((arrayCounter+=1))
		((fieldCounter+=1))
	done
	((fieldCounter-=2))
	temp=${fieldsArray[fieldCounter]}
	fieldsArray[$fieldCounter]="$1"
	((fieldCounter+=1))
	fieldsArray[$fieldCounter]="$2"
	((fieldCounter+=1))
	fieldsArray[$fieldCounter]="$temp"
	updateTableSchema
	updateDBSchema
	updateRows $1 $2
	echo "Table Structure Updated"
}

# Update Table Schema
function updateTableSchema
{
	`sed -i '1,$d' databases/$currentDb/${tbName}_Schema`
	for ((i=0;i<="$fieldCounter";i++))
	do
		if [ $i -eq $fieldCounter ]
		then
			echo -e "${fieldsArray[i]}\c" >> databases/$currentDb/${tbName}_Schema
		else
			echo -e "${fieldsArray[i]},\c" >> databases/$currentDb/${tbName}_Schema
		fi
	done 
}

# Update Database Schema
function updateDBSchema
{
	sed -i "/$tbName,/d" "databases/$currentDb/Schema"
	for ((i=0;i<="$fieldCounter";i++))
	do
		if [ $i -eq $fieldCounter ]
		then
			echo -e "${fieldsArray[i]}\c" >> databases/$currentDb/Schema
		elif [ $i -eq 0 ]
		then
			echo -e "$tbName,${fieldsArray[i]}\c" >> databases/$currentDb/Schema
		else
			echo -e "${fieldsArray[i]},\c" >> databases/$currentDb/Schema
		fi
	done 
}

# Update Rows 
function updateRows
{
	dataLoopCounter=`awk -F, '{ if(NR == 1)print NF }' databases/$currentDb/$tbName 2>>./.error.log`
	dataLinesCounter=`cat databases/$currentDb/$tbName | wc -l 2>>./.error.log`
	
	typeset dataFieldsArray[2]
	for ((line=0;line<"$dataLinesCounter";line++))
	do 
		((dateFieldCounter=1))
		((arrayCounter=0))
		for ((j=0;j<"$dataLoopCounter";j++))
		do
			i=`sed -n '1p' databases/$currentDb/$tbName | cut -f$dateFieldCounter -d, 2>>./.error.log`
			dataFieldsArray[$arrayCounter]=$i
			((arrayCounter+=1))
			((dateFieldCounter+=1))
		done
		((dateFieldCounter-=2))
		tempPrimaryValue=${dataFieldsArray[dateFieldCounter]}
		((dateFieldCounter-=1))
		tempPrimary=${dataFieldsArray[dateFieldCounter]}
		dataFieldsArray[$dateFieldCounter]="$1"
		((dateFieldCounter+=1))
		dataFieldsArray[$dateFieldCounter]="$2"
		((dateFieldCounter+=1))
		dataFieldsArray[$dateFieldCounter]="$tempPrimary"
		((dateFieldCounter+=1))
		dataFieldsArray[$dateFieldCounter]="$tempPrimaryValue"

		sed -i "1d" "databases/$currentDb/$tbName"
		for ((i=0;i<="$dateFieldCounter";i++))
		do
			if [ $i -eq $dateFieldCounter ]
			then
				echo "${dataFieldsArray[i]}" >> databases/$currentDb/$tbName
			else
				if [[ ${dataFieldsArray[$i]} = 'int' || ${dataFieldsArray[$i]} = 'varchar' || ${dataFieldsArray[$i]} = 'string' ]]
				then
					echo -e ",\c" >> databases/$currentDb/$tbName
				else
					echo -e "${dataFieldsArray[i]},\c" >> databases/$currentDb/$tbName
				fi
			fi
		done
	done 
}

# Update Rows Data
function updateRowData 
{
	echo -e "Enter Column Name: \c"
	read columnName

	echo -e "Enter Previous Column Value: \c"
	read previousValue

	echo -e "Enter New Column Value: \c"
	read newValue
	
	typeset arrayRows[2]
	index=0
	isPrimaryKey=0

	fieldLoopCounter=`awk -F, '{ print NF }' databases/$currentDb/${tbName}_Schema 2>>./.error.log`
	columnLines=`awk 'BEGIN{FS=","}{for(i=1;i<=NF;i++){if($i=="'$columnName'"){j=i+1; if($j == "'$previousValue'"){print NR}}}}' databases/$currentDb/$tbName 2>>./.error.log`
	columnDataType=`awk 'BEGIN{FS=","}{for(i=1;i<=NF;i++){if($i=="'$columnName'"){j=i+1; {print $j; i=NF+1}}}}' databases/$currentDb/${tbName}_Schema 2>>./.error.log`
	typeset fieldsArray[2]
	((fieldCounter=1))
	((arrayCounter=0))
	for ((j=0;j<"$fieldLoopCounter";j++));do
		i=`cat databases/$currentDb/${tbName}_Schema | cut -f$fieldCounter -d,`
		if [ $i != "int" -a $i != "varchar" -a $i != "string" ]
		then 
			fieldsArray[$arrayCounter]=$i
			((arrayCounter=arrayCounter+1))
		fi
		((fieldCounter=fieldCounter+1))
	done
	
	if [[ -n $columnLines ]]
	then	
		if [ ${fieldsArray[((arrayCounter-1))]} = $columnName ]
		then
			((isPrimaryKey=1)) 
			for i in `awk -F, '{print $NF}' databases/$currentDb/$tbName 2>>./.error.log`
			do
				if [ $newValue = $i ]
				then
					echo "Error, primary key exist"
					return
				fi
			done
		fi


		source ./dataType.sh "checkUserInput" $newValue $columnDataType
		if [ $userInputDatatype -eq 1 ]
    	then
			if [ $isPrimaryKey -eq 1 ]
			then
			    sed -i "s/$columnName,$previousValue/$columnName,$newValue/g" "databases/$currentDb/$tbName" 
			else
				sed -i "s/,$columnName,$previousValue,/,$columnName,$newValue,/g" "databases/$currentDb/$tbName" 
			fi
			echo "Value/Values updated successfully"
    	else
        	echo "Error, wrong datatype"
    	fi 
	else
		echo "You Enter Invalid Column Or Data"
	fi		
}

update