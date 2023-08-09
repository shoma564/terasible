#!/bin/bash
sshpass -p tmcit ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub tmcit@172.24.20.201
sshpass -p tmcit ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub tmcit@172.24.20.202
sshpass -p tmcit ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub tmcit@172.24.20.203
sshpass -p tmcit ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub tmcit@172.24.20.204
sshpass -p tmcit ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub tmcit@172.24.20.205
