#!/bin/bash

echo "manage_etc_hosts: true" >> /etc/cloud/cloud.cfg

cat <<EOF > "/etc/cloud/templates/hosts.debian.tmpl"
## template:jinja
{#
This file (/etc/cloud/templates/hosts.tmpl) is only utilized
if enabled in cloud-config.  Specifically, in order to enable it
you need to add the following to config:
   manage_etc_hosts: True
-#}
# Your system has configured 'manage_etc_hosts' as True.
# As a result, if you wish for changes to this file to persist
# then you will need to either
# a.) make changes to the master file in /etc/cloud/templates/hosts.tmpl
# b.) change or remove the value of 'manage_etc_hosts' in
#     /etc/cloud/cloud.cfg or cloud-config from user-data
#
{# The value '{{hostname}}' will be replaced with the local-hostname -#}
127.0.0.1 localhost
127.0.1.1 {{fqdn}} {{hostname}}

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

# Comment out swap line so node can handle reboot without manual intervention

sed -e '/swap/ s/^#*/#/' -i /etc/fstab