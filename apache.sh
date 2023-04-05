#!/bin/bash

# update packages
sudo yum update

# apache install, enable, and status check
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
