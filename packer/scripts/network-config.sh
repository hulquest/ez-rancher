
# Overwrite /etc/network/interfaces - we only want explicit ENI network configuration from cloud-init
# the cloud-init network configuration gets written under /etc/network/interfaces.d/
cat <<EOF > "/etc/network/interfaces"
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

EOF
