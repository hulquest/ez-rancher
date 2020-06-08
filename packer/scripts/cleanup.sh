#!/bin/bash -eux

# From https://github.com/box-cutter/debian-vm/blob/master/script/cleanup.sh

CLEANUP_PAUSE=${CLEANUP_PAUSE:-0}
echo "==> Pausing for ${CLEANUP_PAUSE} seconds..."
sleep ${CLEANUP_PAUSE}

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "==> Cleaning up udev rules"
rm -rf /dev/.udev/
rm -rf /etc/udev/rules.d/70-persistent-net.rules
rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules

echo "==> Cleaning up leftover dhcp leases"
if [ -d "/var/lib/dhcp" ]; then
    rm -rf /var/lib/dhcp/*
fi

echo "==> Set locale"
cat <<EOF >> /etc/environment
LC_ALL=en_US.UTF-8
LANGUAGE=en_US.UTF-8
EOF

echo "==> Cleaning up tmp"
rm -rf /tmp/*

# Cleanup apt cache
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

echo "==> Installed packages"
dpkg --get-selections | grep -v deinstall

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Clean up log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Skipping the whiteout part from box-cutter -- which would just fill up the qcow2 image

# # Whiteout root
# count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
# let count--
# dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
# rm /tmp/whitespace

# # Whiteout /boot
# count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
# let count--
# dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
# rm /boot/whitespace

# # Zero out the free space to save space in the final image
#dd if=/dev/zero of=/EMPTY bs=1M
#rm -f /EMPTY

#Discard unused storage
fstrim -av

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early
sync
