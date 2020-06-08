#!/bin/bash

wget https://github.com/rancher/rke/releases/download/v1.0.6/rke_linux-amd64
chmod +x rke_linux-amd64
mv rke_linux-amd64 /usr/local/bin/rke

for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_conntrack_ipv4   nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set  xt_statistic xt_tcpudp;
  do
    if ! lsmod | grep -q $module; then
      echo "module $module is not present, installing now...";
	    modprobe $module
    fi;
done

echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
