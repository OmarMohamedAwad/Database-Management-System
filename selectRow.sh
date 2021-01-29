#!/bin/bash
#########Check table existance#############################
echo -e "Insert table name: \c"
read tblName
if [ -z $tblName ]
then
    echo "Error, empty input"
    echo "Back to table menu"
    exit
fi
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
    echo "Back to table menu"
    exit
fi
#############################################################
#calculate number of rows
numberOfRows=`wc -l databases/$currentDb/${tblName} | cut -f1 -d' '`
#echo $numberOfRows
#############################################################
#to count no of fields in the table
fieldLoopCounter=`awk -F, '{ print NF }' databases/$currentDb/${tblName}_Schema `
#echo $fieldLoopCounter
#################################################################
#to know columns of this table
typeset fieldsArray[2]
((fieldCounter=1))
((arrayCounter=0))
for ((j=0;j<"$fieldLoopCounter-1";j++));do
    i=`cat databases/$currentDb/${tblName}_Schema | cut -f$fieldCounter -d,`
    if [ $i != "int" -a $i != "varchar" -a $i != "string" ]
    then
        fieldsArray[$arrayCounter]=$i
        ((arrayCounter=arrayCounter+1))
    fi
    ((fieldCounter=fieldCounter+1))
done
# echo ${fieldsArray[@]}
# echo $arrayCounter
###############################################################
function searchValue
{
    echo $1 $2
    typeset dataExistFlag
    ((dataExistFlag=0))
    for ((i=0;i<"$numberOfRows";i++));do
        ((linesCounter=i+1))
        element=`head -$linesCounter databases/$currentDb/${tblName} | tail -1 | cut -f$1 -d,`
        if [[ $element = $2 ]]
        then
            ((dataExistFlag=1))
            displayData 1 $linesCounter 
        fi
    done
    if [ $dataExistFlag -eq 0 ]
    then
        echo "Error, Data dose not exist"
        return
    fi
    # q=`head -$linesCounter databases/$currentDb/${tblName} | tail -1`
    # echo $q 
      
}
##############################################################
typeset clmnIsExist
typeset clmnID #this will be used to exclusively serch the fields of the entered 
               #clmn for the entred value by the user
function checkClmn
{
    ((clmnIsExist=0))
    ((clmnID=0))
    for ((i=0;i<"$fieldLoopCounter";i++));do
        ((clmnID=clmnID+2))
        if [[ $1 = ${fieldsArray[i]} ]]
        then
            ((clmnIsExist=1))
            break
        fi
    done
    if [ $clmnIsExist -eq 0 ]
    then 
        echo "Error, column dose not exist"
        return
    fi
    echo -e "Insert value: \c"
    read clmnValue
    if [ -z $clmnValue ]
    then
        echo "Error, empty value"
        return
    fi
    searchValue $clmnID $clmnValue
}
#############################################################
typeset -i firstRowFlag
((firstRowFlag=0))
function displayData
{
    if [ $firstRowFlag -eq 0 ]
    then
        ((firstRowFlag=1))
        echo "----------------------------------------------------------"
        echo -e "|\c"
        for ((j=0;j<"$arrayCounter-1";j++));do
            echo -e "${fieldsArray[j]}          |\c"
        done
        echo "${fieldsArray[j]}          "
        echo "----------------------------------------------------------"
    fi
    if [ $1 -eq 0 ] 
    then
        typeset dataArray[1]
        typeset dataArrayCounter=0
        typeset linesCounter=0
        for ((i=0;i<"$numberOfRows";i++));do
            ((dataArrayCounter=0))
            for ((j=2;j<"$fieldLoopCounter";j=j+2));do
                ((linesCounter=i+1))
                element=`head -$linesCounter databases/$currentDb/${tblName} | tail -1 | cut -f$j -d,`
                dataArray[$dataArrayCounter]=$element
                ((dataArrayCounter=dataArrayCounter+1))
            done
            echo -e "|\c"
            for ((k=0;k<"$dataArrayCounter-1";k++));do  
                echo -e "${dataArray[k]}          |\c" 
            done
            echo "${dataArray[k]}          "
            echo "----------------------------------------------------------"
        done
        return
    elif [ $1 -eq 1 ]
    then
        ((dataArrayCounter=0))
        for ((j=2;j<"$fieldLoopCounter";j=j+2));do
            ((linesCounter=i+1))
            element=`head -$linesCounter databases/$currentDb/${tblName} | tail -1 | cut -f$j -d,`
            dataArray[$dataArrayCounter]=$element
            ((dataArrayCounter=dataArrayCounter+1))
        done
        echo -e "|\c"
        for ((k=0;k<"$dataArrayCounter-1";k++));do  
            echo -e "${dataArray[k]}          |\c" 
        done
        echo "${dataArray[k]}          "
        echo "----------------------------------------------------------"
    fi
}
###############################################################
select choice in "Select all" "Select Row" "Exit"
do
    case $choice in
        "Select all")
                ((firstRowFlag=0))
                displayData 0 
            ;;
        "Select Row")
                echo -e "Insert column name: \c"
                read clmnName
                if [ -z $clmnName ]
                then
                    echo "Error, empty input"
                else
                        ((firstRowFlag=0))
                        checkClmn $clmnName
                fi
            ;;
        "Exit")
                echo "Back to table menu"
                exit
            ;;
        *)
                echo "Invalid choice"
            ;;
    esac
done