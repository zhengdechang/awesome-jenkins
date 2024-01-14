#!/bin/bash

if [[ -n $GIT_REPO ]]; then
  REPO=$GIT_REPO
fi

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

# 检查 id_rsa 文件是否存在
if [ -f id_rsa ]; then
    echo "id_rsa file found. Copying to /srv/"
    cp id_rsa /srv/
else
    echo "id_rsa file not found. Skipping copy."
fi

if ansible --version; then
    git clone https://github.com/zhengdechang/awesome-jenkins.git --recursive 
    cd awesome-jenkins/awesome-ansible
    if [[ -n $REPO ]]; then
        ansible-playbook -i environment/hosts setup_jenkins.yml -v --user=jancsitech  --connection=ssh \
        --ssh-extra-args="-o StrictHostKeyChecking=no" -e "ansible_ssh_user=${username} ansible_ssh_pass=${password} ansible_become_pass=${password} github_save_repo=${REPO}"
    else
        ansible-playbook -i environment/hosts setup_jenkins.yml -v --user=jancsitech  --connection=ssh \
        --ssh-extra-args="-o StrictHostKeyChecking=no" -e "ansible_ssh_user=${username} ansible_ssh_pass=${password} ansible_become_pass=${password}"
fi

   
else
    echo "Ansible installation failed."
    exit 1
fi
