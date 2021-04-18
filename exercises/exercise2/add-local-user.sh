#!/bin/bash

# Create local user by taking input from the user
# Only superuser/root has the priviledges to do so.

# Store loggerd in user's username
LOGGED_USER_NAME="$(id -un)"

# Check if user executing this script is a superuser or root
if [[ "${UID}" -ne 0 ]]
then 
    echo "You are not authorized to execute this script"
    exit 1
else
    echo "Welcome, ${LOGGED_USER_NAME}. Please follow along to create a local user account"
fi

# ask for user name
read -p "Please enter the username for user accout to create: " LOCAL_USER_NAME

# ask for user's real name
read -p "Please enter the comment for user accout to create: " LOCAL_COMMENT

# ask for password
read -p "Please enter the password for user accout to create: " LOCAL_PASSWORD

# Create user account with provided username and comment
useradd -c "${LOCAL_COMMENT}" -m ${LOCAL_USER_NAME}

if [[ "${?}" -ne 0 ]]
then
    echo "Some issue with the script. exitting."
    exit 1
fi

# Set password for the useraccount created
echo "${LOCAL_PASSWORD}" | passwd --stdin ${LOCAL_USER_NAME}
if [[ "${?}" -ne 0 ]]
then
    echo "Some issue with the script. exitting."
    exit 1
fi
# force the user to change password on first login
passwd -e ${LOCAL_USER_NAME}
if [[ "${?}" -ne 0 ]]
then
    echo "Some issue with the script. exitting."
    exit 1
fi

# Show relevant 
echo "Created username: ${LOCAL_USER_NAME}"
echo "password: ${LOCAL_PASSWORD}"
echo "Host: $(hostname -s)"