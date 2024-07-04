#!/bin/bash

# function to install some packages if they are not installed
install_packages() {
   if command -v apt-get &>/dev/null; then
         sudo apt-get update
         sudo apt-get install -y passwd openssl || echo "Failed to install packages"
    elif command -v yum &>/dev/null; then
        sudo yum install -y passwd openssl || echo "Failed to install packages"
    fi
}

# Install the required packages
install_packages

# Check if the input file with employee names is provided 
if [ -z "$1" ]; then
    echo "Usage: $0 file_with_employee_names.txt"
    exit 1
fi

input_file=$1

# Check if the input file exists
if [ ! -f $input_file ]; then
    echo "File $input_file does not exist"
    exit 1
fi

# Creating secure files and directories if they do not exist
sudo mkdir -p /var/secure
sudo touch /var/secure/user_passwords.txt /var/secure/user_passwords.csv
sudo touch /var/log/user_management.log

while IFS= read -r line; do 
    username=$(echo $line | cut -d';' -f1)
    groups=$(echo $line | cut -d';' -f2 | tr ',' ' ')

    if id $username &>/dev/null; then
        echo "User $username already exists" | tee -a /var/log/user_management.log
        continue
    fi

    # Create the User and Group
    sudo useradd -m -s /bin/bash $username
    sudo groupadd $username
    sudo usermod -a -G $username $username

    # Adding additional groups
    for group in $groups; do
        sudo groupadd $group
        sudo usermod -a -G $group $username
    done

    echo "User $username has been created and assigned to groups: $groups" | tee -a /var/log/user_management.log

    # Ensure home directory permissions are set correctly
    home_dir="/home/$username"
    sudo chmod 700 $home_dir
    sudo chown $username:$username $home_dir
    echo "Home directory permissions for $username have been set" | sudo tee -a /var/log/user_management.log
    
    # Generate a random password and set it for the user
    password=$(openssl rand -base64 12)
    echo "$username:$password" | sudo chpasswd

    # Check if the user already exists in the Password file before storing the password in a secure file
    if grep -q "^$username" /var/secure/user_passwords.txt; then
        echo "User $username already exists in the password file" | tee -a /var/log/user_management.log
    else
        echo "$username:$password" | sudo tee -a /var/secure/user_passwords.txt
        echo "User $username has been added to the password file" | tee -a /var/log/user_management.log
    fi

    # Check if the user already exists in the Password file
    if grep -q "^$username," /var/secure/user_password.csv; then
        echo "User $username already exists in the password file" | tee -a /var/log/user_management.log
    else
        echo "$username,$password" | sudo tee -a /var/secure/user_passwords.csv
        echo "User $username has been added to the password file" | tee -a /var/log/user_management.log
    fi

done < $input_file

# Secure the password files
sudo chown root:root /var/secure/user_passwords.txt /var/secure/user_passwords.csv
sudo chmod 600 /var/secure/user_passwords.txt /var/secure/user_passwords.csv

echo "User creation process has been completed successfully"