#!/bin/bash

# This script pings a list of servers and reports their status

SERVER_FILE_PATH='/vagrant/servers'

if [[ ! -e "${SERVER_FILE_PATH}" ]]
then
    echo "Cannot open ${SERVER_FILE_PATH}." >&2
    exit 1
fi

for SERVER in $(cat "${SERVER_FILE_PATH}")
do
    echo "Pinging ${SERVER}"
    ping -c 1 ${SERVER} &> /dev/null

    if [[ "${?}" -ne 0 ]]
    then
        echo "${SERVER} down."
    else 
        echo "${SERVER} up."
    fi
done