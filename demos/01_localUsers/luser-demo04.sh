#!\bin\bash

# This script creates an account on the local system.
# You will be prompted for account name and password

# Ask for the user name
read -p 'Enter the username to create: ' USER_NAME

# Ask for the real name
read -p 'Enter the name of the person for whom this account is for: ' USER_COMMENT

# Ask for the password
read -p 'Enter the password for the account to create: ' USER_PASSWORD

# Create the user
useradd -c "${USER_COMMENT}" -m ${USER_NAME}

# Set the password for the user
echo ${USER_PASSWORD} | passwd --stdin ${USER_NAME} 

# Force password change on the first login
passwd -e ${USER_NAME}