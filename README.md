# packer-ansible

## Overview

This repository uses [Packer](https://www.packer.io/) to build a virtual machines for
VMware, VirtualBox, or AWS AMI.

### Contents

1. [Expectations](#expectations)
1. [Build](#build)
    1. [Prerequisite software](#prerequisite-software)
    1. [Clone repository](#clone-repository)
    1. [Custom var file](#custom-var-file)
    1. [Packer Cache](#packer-cache)
    1. [Ansible Mode](#ansible-mode)
    1. [Build using template-centos](#build-using-template-centos)
    1. [Build using template-debian](#build-using-template-debian)
    1. [Build using template-ubuntu](#build-using-template-ubuntu)
1. [Run on VMware Workstation](#run-on-vmware-workstation)
1. [Run on Vagrant / VirtualBox](#run-on-vagrant--virtualbox)
    1. [Add to library](#add-to-library)
    1. [Run](#run)
    1. [Login to guest machine](#login-to-guest-machine)
    1. [Find guest machine IP address](#find-guest-machine-ip-address)
    1. [Remote login to guest machine](#remote-login-to-guest-machine)
    1. [Remove image from Vagrant library](#remove-image-from-vagrant-library)
1. [Troubleshoot](#troubleshoot)
1. [References](#references)

#### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 2 hours to create the virtual machine.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Packer](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/packer.md)

## Build

### Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. [make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
1. [packer](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-packer.md)
1. Builders (not all may be needed):
    1. [AWS command line interface](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-aws-cli.md)
    1. [GCP command line interface](https://cloud.google.com/sdk/install)
    1. [VMware Workstation](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-vmware-workstation.md)
    1. [Vagrant](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-vagrant.md)
    1. [VirtualBox](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-virtualbox.md)

### Clone repository

For more information on environment variables,
see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md).

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=packer-ansible
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

### Setup

:thinking: The `Makefile` uses the following files to create virtual images:

1. `DISTRIBUTION_TEMPLATE_FILE` - A Packer `template-<DISTRIBUTION>.json` file for every major linux distribution is used in the build.
1. `VERSION_VAR_FILE` - A file with variables specific for each distribution's version.
1. `CUSTOM_VAR_FILE` - A user-configurable file specifying values to use during the build.

All three files must be declared as environment variables before creating virtual images.

```console
export TEMPLATE_FILE=~/my-vars/my-custom-var.json
```

In the examples below, the `CUSTOM_VAR_FILE` is set to `vars/custom-var.json`
In practice, this value should be modified to point to a user's custom file of variables.

The `CUSTOM_VAR_FILE`, can be used to:

1. Specify an [Ansible playbook](docs/PLAYBOOK_SETUP.md)
1. Specify an [Ansible version](https://pypi.org/project/ansible/#history) (default: latest)
1. Add Multifactor Authentication information
1. Specify SSH keys
1. Change disk or memory size
1. Specify an [AMI Marketplace Image](docs/AWS_MARKETPLACE_SETUP.md)

Example:

```console
export CUSTOM_VAR_FILE=~/my-vars/my-custom-var.json
```

### Packer Cache

:pencil2: Packer cache the downloaded images into a folder called packer_cache. By default, the packer_cache folder is created in the packer-ansible folder. To modify the location of the packer cache folder, simply export the following variable:

Example:

```consol
export PACKER_CACHE_DIR=/path/to/packer_cache
```

### Ansible Mode

:pencil2: The Ansible installation on the image can be adjusted with the following modes:

1. `install` - The Ansible package is installed, used and remains on the image.
1. `ephemeral` - The Ansible package is installed, used and then removed from the image.
1. `none` - The Ansible package is never installed on the image (default).

Example:

```consol
export ANSIBLE_MODE=install
```

### Build using template-centos

#### CentOS 7.6

Example: amazon-ebs (Before creating AMIs, go through the [AWS AMI setup](docs/AWS_AMI_SETUP.md) first)

```console
cd ${GIT_REPOSITORY_DIR}
export TEMPLATE_FILE=template-centos.json
export VERSION_VAR_FILE=vars/centos-07.06.json
export CUSTOM_VAR_FILE=vars/custom-var.json
make amazon-ebs
```

To build GCP Compute Images (Before creating images, go through the [GCP Compute Image setup](docs/GCP_IMAGE_SETUP.md) first), instead of `make amazon-ebs`, run the following:

```console
make googlecompute
```

To build virtualbox, instead of `make amazon-ebs`, run the following:

```console
make virtualbox-iso
```

To build vmware-iso, instead of `make amazon-ebs`, run the following:

```console
make vmware-iso
```

#### CentOS 8.2

Example: amazon-ebs

```console
cd ${GIT_REPOSITORY_DIR}
export TEMPLATE_FILE=template-centos.json
export VERSION_VAR_FILE=vars/centos-08.02.json
export CUSTOM_VAR_FILE=vars/custom-var.json
make amazon-ebs
```

To build GCP Compute Images (Before creating images, go through the [GCP Compute Image setup](docs/GCP_IMAGE_SETUP.md) first), instead of `make amazon-ebs`, run the following:

```console
make googlecompute
```

To build virtualbox, instead of `make amazon-ebs`, run the following:

```console
make virtualbox-iso
```

To build vmware-iso, instead of `make amazon-ebs`, run the following:

```console
make vmware-iso
```

### Build using template-debian

#### Debian 9.12

Example: amazon-ebs

```console
cd ${GIT_REPOSITORY_DIR}
export TEMPLATE_FILE=template-debian.json
export VERSION_VAR_FILE=vars/debian-09.12.00.json
export CUSTOM_VAR_FILE=vars/custom-var.json
make amazon-ebs
```

To build GCP Compute Images (Before creating images, go through the [GCP Compute Image setup](docs/GCP_IMAGE_SETUP.md) first), instead of `make amazon-ebs`, run the following:

```console
make googlecompute
```

To build virtualbox, instead of `make amazon-ebs`, run the following:

```console
make virtualbox-iso
```

To build vmware-iso, instead of `make amazon-ebs`, run the following:

```console
make vmware-iso
```

#### Debian 10.04.00

Example: amazon-ebs

```console
cd ${GIT_REPOSITORY_DIR}
export TEMPLATE_FILE=template-debian.json
export VERSION_VAR_FILE=vars/debian-10.04.00.json
export CUSTOM_VAR_FILE=vars/custom-var.json
make amazon-ebs
```

To build GCP Compute Images (Before creating images, go through the [GCP Compute Image setup](docs/GCP_IMAGE_SETUP.md) first), instead of `make amazon-ebs`, run the following:

```console
make googlecompute
```

To build virtualbox, instead of `make amazon-ebs`, run the following:

```console
make virtualbox-iso
```

To build vmware-iso, instead of `make amazon-ebs`, run the following:

```console
make vmware-iso
```

### Build using template-ubuntu

#### Ubuntu 18.04.04

Example: amazon-ebs

```console
cd ${GIT_REPOSITORY_DIR}
export TEMPLATE_FILE=template-ubuntu.json
export VERSION_VAR_FILE=vars/ubuntu-18.04.04.json
export CUSTOM_VAR_FILE=vars/custom-var.json
make amazon-ebs
```

To build GCP Compute Images (Before creating images, go through the [GCP Compute Image setup](docs/GCP_IMAGE_SETUP.md) first), instead of `make amazon-ebs`, run the following:

```console
make googlecompute
```

To build virtualbox, instead of `make amazon-ebs`, run the following:

```console
make virtualbox-iso
```

To build vmware-iso, instead of `make amazon-ebs`, run the following:

```console
make vmware-iso
```

## Run on VMware Workstation

1. Choose VMX file
    1. VMware Workstation > File > Open...
        1. Navigate to `.../output-vmware-iso-nnnnnnnnnn/`
        1. Choose `senzing-packer-xxxxxx-nnnnnnnnnn.vmx`
1. Optional: Change networking
    1. Navigate to VMware Workstation > My Computer > senzing-packer-xxxxx-nnnnnnnnnn
    1. Right click on "senzing-packer-xxxxxx-nnnnnnnnnn" and choose "Settings"
    1. Choose "Network Adapter" > "Network Connection" > :radio_button: Bridged: Connected directly to the physical network
    1. Click "Save"
1. Run image
    1. Choose VMware Workstation > My Computer > senzing-packer-xxxxx-nnnnnnnnnn
    1. Click "Start up this guest operating system"
1. Username: vagrant  Password: vagrant

## Run on Vagrant / VirtualBox

### Add to library

1. :pencil2: Identify virtual image metadata.
   Example:

    ```console
    export VAGRANT_NAME=packer-xxxxxx-virtualbox
    export VIRTUALBOX_FILE=./senzing-packer-xxxxxx-virtualbox-nnnnnnnnnn.box
    ```

1. Add VirtualBox image to `vagrant`
   Example:

    ```console
    vagrant box add --name=${VAGRANT_NAME} ${VIRTUALBOX_FILE}
    ```

### Run

An example of how to run in a new directory.

#### Specify directory

In this example the `/tmp/packer-ubuntu-18.04` directory is used.

```console
export VAGRANT_DIR=/tmp/${VAGRANT_NAME}
```

#### Initialize directory

Back up an old directory and initialize new directory with Vagrant image.

```console
mv ${VAGRANT_DIR} ${VAGRANT_DIR}.$(date +%s)
mkdir ${VAGRANT_DIR}
cd ${VAGRANT_DIR}
vagrant init ${VAGRANT_NAME}
```

#### Enable remote login

Modify Vagrantfile to allow remote login by
uncommenting `config.vm.network` in `${VAGRANT_DIR}/Vagrantfile`.
Example:

```console
sed -i.$(date +'%s') \
  -e 's/# config.vm.network \"public_network\"/config.vm.network \"public_network\"/g' \
  ${VAGRANT_DIR}/Vagrantfile
```

#### Start guest machine

```console
cd ${VAGRANT_DIR}
vagrant up
```

### Login to guest machine

```console
cd ${VAGRANT_DIR}
vagrant ssh
```

### Find guest machine IP address

In the vagrant machine, find the IP address.

```console
ip addr show
```

### Remote login to guest machine

SSH login from a remote machine.

```console
ssh vagrant@nn.nn.nn.nn
```

Password: vagrant

### Remove image from Vagrant library

To remove Vagrant image, on host machine:

```console
vagrant box remove ${VAGRANT_NAME}
```

## Troubleshoot

If the following error surfaces

```console
Build 'vmware-iso' errored: Error detecting host IP: Could not find vmnetdhcp conf file:
```

To resolve the error, include the following in the template's vmware-iso builder,

`"network": "vmnet8"`

## References

1. [Build dependencies](https://github.com/docktermj/KnowledgeBase/blob/master/build-dependencies/packer.md).
1. [Bibliography](https://github.com/docktermj/KnowledgeBase/blob/master/bibliography/packer.md)
