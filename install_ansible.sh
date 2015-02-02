# install
cd ~/
git clone git://github.com/ansible/ansible.git --recursive
cd ansible
source ./hacking/env-setup
sudo easy_install pip
sudo pip install paramiko PyYAML Jinja2 httplib2

