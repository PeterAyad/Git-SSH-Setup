#!/bin/bash

# Set the SSH directory path
dir=~/.ssh

# Check if the .ssh directory exists
if [[ ! -e $dir ]]; then
    # If it doesn't exist, create it
    mkdir $dir
elif [[ ! -d $dir ]]; then
    # If it exists but is not a directory, exit with a message
    echo "$dir already exists but is not a directory"
    exit 0
fi

# Change to the .ssh directory
cd $dir

# Prompt the user for their GitHub username
printf "\n Github account username: "
read input
git config --global user.name "$input"  # Set Git global username

# Prompt the user for their GitHub email
printf "\n Github account email: "
read input
git config --global user.email "$input"  # Set Git global email

# Generate a new SSH key (RSA 4096 bits) with the provided email, saved as 'id_github'
ssh-keygen -t rsa -b 4096 -C $input -f id_github -q -N ""

# Create SSH config file entry for GitHub
echo "Host github.com" >> config
echo "    IdentityFile ~/.ssh/id_github" >> config

# Secure the SSH config file
chmod 600 config

# Start the SSH agent in the background
eval $(ssh-agent -s)

# Add the newly generated SSH key to the agent
ssh-add id_github

# Add GitHub to known hosts (prevents SSH warnings)
ssh-keyscan -t rsa github.com >> known_hosts

# Clear the screen for better readability
clear

# Show public key and ask user to copy it to GitHub
printf "Copy this code to github.com > settings > SSH and GPG keys > New SSH Key : \n \n "
cat id_github.pub

# Wait for user confirmation before testing the SSH connection
printf "\n \n Press enter when finished to test the connection: "
read input

# Test the SSH connection to GitHub
ssh -T git@github.com
