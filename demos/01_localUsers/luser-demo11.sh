#!/bin/bash

# This script generates a password.
# The user can set the password length with -l and add a special character with -s.
# Verbose mode can be enabled with -v  

usage(){
    echo "Usage: ${0} [-vs] [-l LENGTH]" >&2 # ${0} -> script name
    echo 'Generate a random password.'
    echo '  -l LENGTH   Specify the password length.'
    echo '  -s          Append a special character to the password.'
    echo '  -v          Increase verbosity.'
    exit 1
}

log(){
    local MESSAGE="${@}" # ${@} -> params received in this function
    if [[ "${VERBOSE}" = 'true' ]]
        then 
            echo "${MESSAGE}"
    fi
}

# Set a default length of password
LENGTH=48

while getopts vl:s OPTION
do
    case ${OPTION} in
        v)
            VERBOSE='true'
            log 'Verbose mode ON.'
            ;;
        l)
            LENGTH="${OPTARG}"
            ;;
        s)
            USE_SPECIAL_CHARACTER='true'
            ;;
        ?)
            usage
            ;;
    esac
done

log 'Generating a password.'

# Generate the password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

#  Append a spcial characte if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
    log 'Selecting a random special character.'
    SPECIAL_CHARACTER=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
    PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password.'

# Display the password
echo "${PASSWORD}"

exit 0 