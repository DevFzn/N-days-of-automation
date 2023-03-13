#!/bin/bash
# This shell script that checks if the required python modules (pip3, boto3, and awscli)
# the terraform package are installed, and installs them if they are missing. 
# This script should work on both CentOS and macOS
# Check the terraform release page to use the latest terraform package https://releases.hashicorp.com/terraform/

# Define Terraform version
TF_VERSION=1.3.9

install_terraform() {
  sudo apt-get -y install wget unzip || sudo yum install -y unzip
  sudo wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
  sudo unzip terraform_${TF_VERSION}_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  sudo chmod +x /usr/local/bin/terraform
  sudo rm terraform_${TF_VERSION}_linux_amd64.zip
}

# Check if pip3 is installed
if ! type "pip3" &> /dev/null
then 
    echo "pip3 is not installed. Installing now ..."
    # Install pip3
    # Checking for Mac
    if [ "$(uname)" == "Darwin" ]
    then
        brew install python3
    # Checking for Centos
    elif [ -f /etc/centos-release ]
    then
        sudo yum -y update
        sudo yum -y install python3-pip -y
    # Checking for Ubuntu
    elif [ -f /etc/lsb-release ]
    then
        sudo apt-get -y update
        sudo apt-get -y install python3-pip
    fi
fi

# Check if boto3 is installed
if python3 -c "import boto3" &> /dev/null; then
    echo "Boto3 is already installed"
else
    echo "Boto3 is not installed. Installing now...."
    pip3 install boto3 --user
fi

# Check if awscli is installed
if ! type "aws" > /dev/null
then
    echo "awscli is not installed. Installing now..."
    pip3 install awscli --user
else
    echo "awscli is already installed"
fi

# Check if terraform is installed
if ! type "terraform" > /dev/null
then
    echo "terraform is not installed installing now..."
    # Install terraform
    #Checking for Mac
    if [ "$(uname)" == "Darwin" ]
    then
        brew install terraform
    # Checking for Centos
    elif [ -f /etc/centos-release ] || [ -f /etc/lsb-release ]
    then
        install_terraform
    fi
else
    echo "Terraform is already installed"
    
fi
