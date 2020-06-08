#!/bin/bash
# Install open vm tools for vmware

export DEBIAN_FRONTEND="noninteractive"
apt-get -y update 
apt-get install -y open-vm-tools
