#!/bin/bash
component=$1
dnf install ansible -y
ansible-pull -U https://github.com/mahi2298/ansible-roboshop-roles-tf.git -e component=$1 main.yaml