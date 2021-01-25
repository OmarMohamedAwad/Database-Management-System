#!/bin/bash
#########Check table existance#############################
echo -e "Insert table name: \c"
read tblName
if [ -z $tblName ]
then
    echo "Error, empty input"
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
    exit
fi
echo "" >> databases/$currentDb/$tblName  #to print new line
#################################################################
#to count no of fields in the table
fieldLoopCounter=`awk -F, '{ print NF }' databases/$currentDb/${tblName}_Schema `
#################################################################
#to know fields of this table
typeset fieldsArray[2]
typeset dataTypeArray[2]
((fieldCounter=1))
((arrayCounter=0))
for ((j=0;j<"$fieldLoopCounter";j++));do
    i=`cat databases/$currentDb/${tblName}_Schema | cut -f$fieldCounter -d,`
    if [ $i != "int" -a $i != "char" -a $i != "str" ]
    then 
        fieldsArray[$arrayCounter]=$i
    else
        dataTypeArray[$arrayCounter]=$i
        ((arrayCounter=arrayCounter+1))
    fi
    ((fieldCounter=fieldCounter+1))
done
((arrayCounter=arrayCounter+1))
#echo ${fieldsArray[@]}
#echo ${dataTypeArray[@]}
##################################################################
# function checkDataType
# {
#     echo $1
#     echo $2
#     #check data type
#     for ((i=0;i<"$arrayCounter";i++));do
#         if [ $2 = ${fieldsArray[$i]} ]
#         then 
#             dataTypeEntered=${dataTypeArray[$i]}
#             break
#         fi 
#     done
#     #source ./dataType.sh "checkUserInput" $1 $dataTypeEntered 
#     echo $dataTypeEntered
#     ((userInputDatatype=1))
# }
primaryKeyIsInserted=0
function insertPrimaryKey
{
    echo -e "First, insert primary key value."
    #echo -e "${fieldsArray[((arrayCounter-1))]}: \c"
    read primaryKeyYarab
    echo $primarykeyYarab
    if [ -z $primaryKey ]
    then
        echo "Error, empty input"
        return
    fi
    for i in `awk -F, '{print $NF}' databases/$currentDb/$tblName`
    do
        if [ $primaryKey = $i ]
        then
            echo "Error, primary key exist"
            return
        fi
    done
    echo "start dt check-------"
    echo "test = $primarykey"
    # checkDataType $primarykey ${fieldsArray[((arrayCounter-1))]}
    # if [ userInputDatatype -eq 1 ]
    # then
    #     insertValue $primaryKey 
    # else
    #     echo "Error, wrong datatype"
    # fi 
}
##################################################################
typeset rowData[2]
function insertValue
{
    rowDataCounter=0
    if [ $primaryKeyIsInserted -eq 0 ]
    then
        for ((i=0;i<"$arrayCounter";i++));do
            rowData[$rowDataCounter]=${fieldsArray[i]}
            if [ ${fieldsArray[((arrayCounter-1))]} = ${fieldsArray[i]} ]
            then 
                rowData[(($rowDataCounter+1))]=$primaryKey
            else
                rowData[(($rowDataCounter+1))]=""
            fi
            ((rowDataCounter=rowDataCounter+2))
        done
        primaryKeyIsInserted=1
    else
        # checkDataType $clmnValue $clmnName
        # if [ userInputDatatype -eq 0 ]
        # then
        #     echo "Error, wrong datatype"
        #     return 
        # fi 
        for ((i=0;i<"$arrayCounter";i++));do
            rowData[$rowDataCounter]=${fieldsArray[i]}
            if [ $clmnName = ${fieldsArray[i]} ]
            then 
                rowData[(($rowDataCounter+1))]=$clmnValue
            fi
            ((rowDataCounter=rowDataCounter+2))
        done
        
    fi 
    for ((i=0;i<"$rowDataCounter-1";i++));do
        echo -e "${rowData[i]},\c" >> databases/$currentDb/$tblName
    done 
    echo -e "${rowData[((rowDataCounter-1))]}\c" >> databases/$currentDb/$tblName     
}
#####################################################################
function checkClmn
{
    ((clmnIsExist=0))

    echo $fieldLoopCounter
    echo "${fieldsArray[@]}"

    for ((i=0;i<"$fieldLoopCounter";i++));do
        if [ $1 = ${fieldsArray[i]} ]
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
    insertValue $clmnValue
}
###############################################################
select choice in "Insert Column" "Exit"
do
    case $choice in
        "Insert Column")
                if [ $primaryKeyIsInserted -eq 0 ]
                then 
                    insertPrimaryKey
                else
                    echo -e "Insert column name: \c"
                    read clmnName
                    if [ -z $clmnName ]
                    then
                        echo "Error, empty input"
                    else
                        checkClmn $clmnName
                    fi
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

   