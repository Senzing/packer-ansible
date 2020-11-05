#!/usr/bin/env bash

# Install Ansible dependencies.

if [ $1 == 'true' ]
then
  sudo apt -y update && sudo apt-get -y upgrade
  sudo apt -y install python3-pip python3-dev git

  # Install Ansible.

  # if ansible version is set, install that version, else install the latest ansible
  if [ ! -z "${ANSIBLE_VERSION}" ]
  then
    sudo pip3 install ansible==${ANSIBLE_VERSION}
  else
    sudo pip3 install ansible
  fi
fi
