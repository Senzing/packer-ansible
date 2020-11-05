#!/usr/bin/env bash

if [ $1 == 'true' ]
then
  # Install Ansible repository.

  sudo apt -y update && apt-get -y upgrade
  sudo apt -y install software-properties-common
  sudo apt -y install python3-pip python3-dev git
  sudo apt-add-repository ppa:ansible/ansible
  sudo apt -y update

  # Install Ansible.

  # if ansible version is set, install that version, else install the latest ansible
  if [ ! -z "${ANSIBLE_VERSION}" ]
  then
    sudo pip3 install ansible==${ANSIBLE_VERSION}
  else
    sudo pip3 install ansible
  fi
fi
