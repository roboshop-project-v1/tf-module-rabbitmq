#!/bin/bash


sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
yum install ansible -y &>>/opt/userdata.log
pip3 install botocore boto3  &>>/opt/userdata.log
ansible-pull -i localhost, -U https://github.com/roboshop-project-v1/roboshop-ansible.git main.yml -e component=rabbitmq &>>/opt/userdata.log
