#!/bin/bash

# Create user account as priviledged user, accept account name and comment as the arguments while exeuting the script.

# Get the logged in user name
LOGGED_IN_USER_NAME="$(id -nu)"
# Check if the logged in user is authorized to create user account

if [[ "${UID}" -ne 0 ]]
then
    echo "${LOGGED_IN_USER_NAME}, isn't authorised to execute this script." >&2  
    exit 1
fi

# Display a welcome message
echo "Welcome, ${LOGGED_IN_USER_NAME}"
echo

# Generate a random password
PASSWORD="$(date +%s%N | sha256sum | head -c8)" 

# Get the user account name and account comment from arguments passed
if [[ "${#}" -lt 1 ]]
then
    echo "Insuffient information provided to the script as arguments. Please refer to the usage of this script." >&2
    echo "script USER_ACCOUNT_NAME [USER_ACCOUNT_COMMENT]... " >&2
    exit
fi
ACCOUNT_NAME=${1}
shift
ACCOUNT_COMMENT=${*}
# echo "Provided account name: ${ACCOUNT_NAME}"
# echo "Provided account comment: ${ACCOUNT_COMMENT}"

# Create user account
useradd -c "${ACCOUNT_COMMENT}" -m "${ACCOUNT_NAME}" &> /dev/null

# Make the user account to change the password on first login
if [[ "${?}" -ne 0 ]]
then 
    echo "Some issue with the script. Please contact the author." >&2
fi

echo "${PASSWORD}" | passwd --stdin "${ACCOUNT_NAME}" &> /dev/null
if [[ "${?}" -ne 0 ]]
then 
    echo "Some issue with the script. Please contact the author." >&2
fi

passwd -e "${ACCOUNT_NAME}"  &> /dev/null
if [[ "${?}" -ne 0 ]]
then 
    echo "Some issue with the script. Please contact the author." >&2
fi

# Display success massage and basic info
echo "User account successfully created."
echo "Created account name: ${ACCOUNT_NAME}"
echo "Created account comment: ${ACCOUNT_COMMENT}"
echo "One time temporary password: ${PASSWORD}"
echo "Hostname: $(hostname -s)"