#!/bin/bash

log(){
    echo 'this is log function'
}

log
echo

logMessage(){
    local MESSAGE="${@}"
    echo "${MESSAGE}"
}
logMessage 'Hello'
logMessage 'World'
echo

logMessageOnCondition(){
    local VERBOSE="${1}"
    shift
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${MESSAGE}"
    fi
}

logMessageOnCondition 'Hello'

logMessageOnCondition 'true' 'BYE'


backup_file(){
    # This function creates a backup of a file. Returns non-zero status on error.
    local FILE="${1}"

    # Make sure the file exists
    if [[ -f "${FILE}" ]]
    then
        local BACKUP_FILE="temp/$(basename ${FILE}).$(date +%F-%N).backup"
        logMessage "Backing up ${FILE} to ${BACKUP_FILE}"

        # The exit status of the function will be the exit status of the cp command.
        # -p in the copy command stands for preserve, and it preserves the file modes, ownership and timestamp 
        cp -p ${FILE} ${BACKUP_FILE}
    else
        # The file doesn't exist, so return a non-zero exit status
        return 1
    fi   
}

backup_file 'temp/test.txt'

# Make a decision based on exit status of the function

if [[ "${?}" -eq 0 ]]
then 
    logMessage 'File backup successful'
else
    logMessage 'File backup failed'
    exit 1
fi