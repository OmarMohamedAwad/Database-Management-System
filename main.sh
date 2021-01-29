#!/bin/bash

databasesIsCreated=0
for count in `ls`
    	do
		if [ $count == "databases" ]
		then
			databasesIsCreated=1
			break
		fi
done
if [ $databasesIsCreated -eq 0 ]
then
	mkdir databases
fi

function changePermissions
{
	for script in `ls`
	do
		chmod +x $script
	done
}
changePermissions
select choice in "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit"
do
    case $choice in
        "Create Database") 
            echo "Creating database"
            ./createDb.sh
        ;;
        "List Databases")
            echo "Listing databases"
            ./listDb.sh "list"
        ;;
        "Connect To Database")
            echo "Connecting to a database"
            ./selectDb.sh
        ;; 
        "Drop Database")
            echo "Dropping a database"
            ./dropDb.sh
        ;;
        "Exit")
            echo "DBMS Exit"
	    exit
        ;;
        *) echo "invaled option"
        ;;
    esac
done
