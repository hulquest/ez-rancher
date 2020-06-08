#!/bin/bash

# Enable serial console
sudo sed -i 's/^GRUB_CMDLINE_LINUX=.*$/GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty1"/g' /etc/default/grub
sudo grep -q 'GRUB_SERIAL_COMMAND' /etc/default/grub && sudo sed -i 's/^GRUB_SERIAL_COMMAND=.*$/GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1"/g' /etc/default/grub || sudo echo 'GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1"' >> /etc/default/grub
sudo update-grub
