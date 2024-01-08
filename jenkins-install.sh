#!/bin/bash

# 读取用户名
echo -n "Enter local username: "
read username

# 读取密码（输入时不会显示在屏幕上）
echo -n "Enter local password: "
read -s password
echo

# 打印输入的用户名，验证密码则不显示
echo "Username: $username"
echo "Password: $password" 


echo "Updating package index..."
sudo apt-get update

echo "Installing Ansible..."
sudo apt-get install -y ansible git sshpass


if ansible --version; then
   git clone https://github.com/zhengdechang/awesome-jenkins.git --recursive 
   cd awesome-jenkins/awesome-ansible
   ansible-playbook -i environment/hosts setup_jenkins.yml -v --user=jancsitech  --connection=ssh \
   --ssh-extra-args="-o StrictHostKeyChecking=no" -e "ansible_ssh_user=${username} ansible_ssh_pass=${password} ansible_become_pass=${password}"
   
else
    echo "Ansible installation failed."
    exit 1
fi
