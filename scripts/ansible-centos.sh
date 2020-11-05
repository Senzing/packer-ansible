#!/usr/bin/env bash

# Install Python.

if [ $1 == 'true' ]
then
  yum -y install python3-pip python3-dev git python-dnf epel-release dnf xz-devel xz
  alternatives --set python /usr/bin/python3

  # Install Ansible.

  if [ ! -z "${ANSIBLE_VERSION}" ]
  then
    sudo pip3 install ansible==${ANSIBLE_VERSION}
  else
    sudo pip3 install ansible
  fi
fi
