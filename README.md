# Linux User Creation Bash Script for Employees
In this project we are writing a bashscript that allows an organization to create users and groups to assign employees into usernames and groups. 

## Requirements

The bashscript takes up various conditions or aims to achieve:
- the bash script should be able to take up a text file with employees’ names' and be able to add and assign them to Linux groups and users. users will have the same group name as their username and the group name won't be written in the text file e.g. bash create_user.sh, file_with_employee_names.txt (added to groups & assigned)
- the user can have multiple groups and each group is delimited or separated by a comma but the usernames and groups are separated by semicolons
- the script should be able to set up home directories with permission and ownership
- the script should generate random passwords for all users and the passwords will be securely stored on /var/secure/user_passwords.txt. this script should also check if the user already exists on this file - return an error message or so.
- the script should log all actions to /var/log/user_management.log (it creates and contains all actions performed by the script)
- the script should store the list of all users and their passwords separated by commas on /var/secure/user.password.cvs. The file owner should be the only one to read it

## To Test the BashScript 
`````
$ git clone https://github.com/jebitok-dev/bashscript4employeemgt
$ cd bashscript4employeemgt
$ chmod +x create_user.sh
$ ./create_user.sh <file_with_employee_names.txt> 

`````

## Technical Article 
- [Technical Article](https://jebitok.hashnode.dev/writing-a-bashscript-using-linux-commands-and-privileges-to-read-employee-users-group) breaking down the bashscript and explaining more about HNG 


## Acknowledgement 
I acknowledge HNG Internship for this DevOps challenge and the opportunity they have offered me and thousands of other talents to gain some hands-on experience in a unique way