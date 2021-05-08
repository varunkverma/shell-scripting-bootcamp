#!/bin/bash

# a shell script that allows for a local Linux account to be disabled, deleted, and optionally archived.

logMessages(){
    local LOG_TYPE="${1}"
    if [[ "${#}" -gt 1 ]]
    then 
        shift
    fi
    local LOG_MESSAGE="${@}"
    case "${LOG_TYPE}" in 
        e|error)
            echo "ERROR: ${LOG_MESSAGE}" >&2
            ;;
        *)
            echo "INFO: ${LOG_MESSAGE}"
            ;;
    esac    
}

usage(){
    echo "usage: ${0} -[ladrh] LOGIN [LOGINS]..."
    echo 'This script supports following operations and options:'
    echo '  1. Disable/lock user account, use -l'
    echo '  2. Archive user account, use -a'
    echo '  3. Delete user account, use -d'
    echo '  4. Remove home directory of user account, use -r'
    echo '  5. to check usage, use -h'
}

validateUserAccount(){
    (id -u ${1})  &>  /dev/null
    if [[ "${?}" -ne 0 ]]
        then
            logMessages e "${1} doesn't exist"
            exit 1 
    fi
}

disableUserAccount(){
    local USER_ACCOUNT_TO_DISABLE="${@}"
    logMessages "disabling UserAccount: ${USER_ACCOUNT_TO_DISABLE}..."

    $(chage -E 0 $USER_ACCOUNT_TO_DISABLE) 1> /dev/null 

    if [[ "${?}" -ne 0 ]]
        then
            logMessages -e "Failed to disable LOGIN: ${USER_ACCOUNT_TO_DISABLE}"
    else
        logMessages "USER ACCOUNT: ${USER_ACCOUNT_TO_DISABLE},  successfully disabled"
    fi

}

archiveUserAccount(){
    local USER_ACCOUNT_TO_ARCHIVE="${@}"
    logMessages "archiving UserAccount: ${USER_ACCOUNT_TO_ARCHIVE}..."

    local ARCHIVE_FILE_PATH="./temp/archives/${USER_ACCOUNT_TO_ARCHIVE}.tar.gz"
    local USER_HOME_DIRECTORY_PATH="/home/${USER_ACCOUNT_TO_ARCHIVE}"
      
    $(tar -zcf $ARCHIVE_FILE_PATH $USER_HOME_DIRECTORY_PATH &> /dev/null) 

    if [[ "${?}" -ne 0 ]]
        then
            logMessages -e "Failed to archive user account: ${USER_ACCOUNT_TO_ARCHIVE}"
    else
        logMessages "USER ACCOUNT: ${USER_ACCOUNT_TO_ARCHIVE},  successfully archived in ${ARCHIVE_FILE_PATH}."
    fi
}

removeUserHomeDirectory(){
    local USER_ACCOUNT_HOME_DIR_TO_DELETE="${@}"
    logMessages "Deleting UserAccount: ${USER_ACCOUNT_HOME_DIR_TO_DELETE}..."
    local USER_HOME_DIRECTORY_PATH="/home/${USER_ACCOUNT_HOME_DIR_TO_DELETE}"  
    $(rm -rf ${USER_HOME_DIRECTORY_PATH} &> /dev/null)

    if [[ "${?}" -ne 0 ]]
        then
            logMessages -e "Failed to delete user account: ${USER_ACCOUNT_HOME_DIR_TO_DELETE}"
    else
        logMessages "USER ACCOUNT HOME DIR: ${USER_ACCOUNT_HOME_DIR_TO_DELETE},  successfully deleted."
    fi
}

deleteUserAccount(){
    local USER_ACCOUNT_TO_DELETE="${@}"
    logMessages "Deleting UserAccount: ${USER_ACCOUNT_TO_DELETE}..."

    $(userdel -fr ${USER_ACCOUNT_TO_DELETE} &> /dev/null)

    if [[ "${?}" -ne 0 ]]
        then
            logMessages -e "Failed to delete user account: ${USER_ACCOUNT_TO_DELETE}"
    else
        logMessages "USER ACCOUNT: ${USER_ACCOUNT_TO_DELETE},  successfully deleted."
    fi

}


# This script requires root privileges
if [[ "${UID}" -ne 0 ]]
then
    logMessages e 'This script requires root privileges'
    exit 1
fi

LOGGED_IN_USER=$(id -nu)
logMessages "Hello, ${LOGGED_IN_USER}"
echo
# check if options are provided

IS_REMOVE_HOME_DIRECTORY=''
IS_ARCHIVE=''
IS_DELETE=''
IS_DISABLE=''

# Loop over the options
while getopts hradl OPTION
do
    case "${OPTION}" in 
        r)
            logMessages 'Option to remove home directory selected'
            IS_REMOVE_HOME_DIRECTORY='true'
            ;;
        a)
            logMessages 'Option to archive user account selected'
            IS_ARCHIVE='true'
            ;;
        d)
            logMessages 'Option to delete user account selected'
            IS_DELETE='true'
            ;;
        l)
            logMessages 'Option to disable/lock user account selected'
            IS_DISABLE='true'
            ;;
        h)
            usage
            exit 1
            ;;
        ?)
            logMessages e 'Incorrect or no option selected'
            usage
            exit 1
            ;;
    esac
done

# remove options
if [[ "${IS_REMOVE_HOME_DIRECTORY}" = 'true' ]]
then
    shift 
fi
if [[ "${IS_ARCHIVE}" = 'true' ]]
then
    shift 
fi
if [[ "${IS_DELETE}" = 'true' ]]
then
    shift 
fi
if [[ "${IS_DISABLE}" = 'true' ]]
then
    shift 
fi

NUM_OF_USERS_TO_PROCESS="${#}"
USERS_TO_PROCESS="${@}"

if [[ "${NUM_OF_USERS_TO_PROCESS}" -lt 1 ]]
    then 
        usage
        exit 1
fi

# Process over all users
while [[ "${NUM_OF_USERS_TO_PROCESS}" -gt 0 ]]
    do    
        # Get the user from list of users
        USER_TO_PROCESS="${1}"
        shift

        validateUserAccount "${USER_TO_PROCESS}"

        if [[ "${?}" -ne 0 ]]
            then 
                logMessages 'Aborting processing for invalid user login.'
        else
    
                    if [[ "${IS_REMOVE_HOME_DIRECTORY}" = 'true' ]]
                        then
                            removeUserHomeDirectory ${USER_TO_PROCESS} 
                    fi
                    if [[ "${IS_ARCHIVE}" = 'true' ]]
                        then
                            archiveUserAccount ${USER_TO_PROCESS}  
                    fi
                    if [[ "${IS_DELETE}" = 'true' ]]
                        then
                            deleteUserAccount ${USER_TO_PROCESS}  
                    fi
                        if [[ "${IS_DISABLE}" = 'true' ]]
                            then
                                disableUserAccount ${USER_TO_PROCESS}  
                        fi

                        NUM_OF_USERS_TO_PROCESS=$((NUM_OF_USERS_TO_PROCESS - 1))        
        fi


    done