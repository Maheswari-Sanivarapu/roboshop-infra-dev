#!/bin/bash

component=$1
dnf install ansible -y
ansible pull -U https://github.com/mahi2298/ansible_roboshop_roles.git -e component=$1 main.yaml