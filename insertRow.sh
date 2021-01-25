#!/bin/bash

#########Check table existance#############################
echo -e "Insert table name: \c"
read tblName
((tblIsExist=0))
#((ClmnCount=0))
for i in `cat databases/$currentDb/Schema | cut -f1 -d,`
do
    #((ClmnCount=ClmnCount+1))
    if [ $i = $tblName ]
    then 
        ((tblIsExist=1))
        break;
    fi
done
if [ $tblIsExist -eq 0 ]
then 
    echo "Error, table dose not exist"
    exit
fi
#################################################################
#to count no of fields in the table
fieldLoopCounter=`awk -F, '{ print NF }' databases/$currentDb/${tblName}_Schema `
#echo $fieldLoopCounter
#################################################################
#to know fields of this table
typeset fieldsArray[2]
((fieldCounter=1))
((arrayCounter=0))
for ((j=0;j<"$fieldLoopCounter";j++));do
    i=`cat databases/$currentDb/${tblName}_Schema | cut -f$fieldCounter -d,`
    if [ $i != "int" -a $i != "char" -a $i != "str" ]
    then 
        fieldsArray[$arrayCounter]=$i
        ((arrayCounter=arrayCounter+1))
    fi
    ((fieldCounter=fieldCounter+1))
done
#echo "${fieldsArray[@]}"
##################################################################
function checkClmn
{
    echo "${fieldsArray[@]}"
    ((clmnIsExist=0))
    for ((i=0;i<"$fieldLoopCounter";i++));do
        if [ ${fieldsArray[i]} =  $clmnName ]
        then
            echo ${fieldsArray[i]}
            ((clmnIsExist=1))
            break;
        fi
    done
    if [ $clmnIsExist -eq 0 ]
    then 
        echo "Error, column dose not exist"
        return
    fi
    echo -e "Insert value: \c"
    read clmnValue 
    echo -e "$clmnName,\c" >> databases/$currentDb/$tblName
    echo -e "$clmnValue,\c" >> databases/$currentDb/$tblName
}
###############################################################
select choice in "Inser Column" "Exit"
do
    case $choice in
        "Inser Column")
                echo -e "Insert column name: \c"
                read clmnName
                checkClmn $clmnName
            ;;
            "Exit")
                echo "Back to table menu"
                echo -e "\n"
                exit
            ;;
            *)
                echo "Invalid choice"
            ;;
    esac
done

   