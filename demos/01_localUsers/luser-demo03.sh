#!/bin/bash

# Display the UID and username of the user executing this script
# Display if the user is the vagrant user or not

# Display the UID
echo "Your UID: ${UID}"

# Only display if the UID isn't 1000
UID_TO_TEST='1000'
if [[ "${UID_TO_TEST}" -ne "${UID_TO_TEST}" ]]
then
    echo "Your UID doesn't match ${UID_TO_TEST}"
    exit 1
fi

# Display the username
USER_NAME="$(id -un)"

if [[ "${?}" -ne 0 ]]
then
    echo "Id command did not execute successfully"
    exit 1
fi

# testing a string condition
USERNAME_TO_TEST='vagrant'
if [[ "${USERNAME_TO_TEST}" = "${USER_NAME}" ]]
then
    echo "Your username match ${USERNAME_TO_TEST}"
fi

# testing for !=
if [[ "${USER_NAME}" != "${USERNAME_TO_TEST}" ]]
then 
    echo "Your username doesn't match ${USERNAME_TO_TEST}"
    exit 1
fi

exit 0