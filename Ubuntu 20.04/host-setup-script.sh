#!/usr/bin/env bash
IFACE="enp5s0"
IP="192.168.0.137"

sudo ip link del br0
echo "Create bridge"
sudo ip link add br0 type bridge
sudo ip link set br0 up

sudo ip link set $IFACE up
sudo ip link set $IFACE master br0

# Keep internet access
sudo ip link add veth1 type veth peer name veth1br
sudo ip link set veth1br master br0
sudo ip addr add 192.168.0.137/24 dev veth1
sudo ip link set dev veth1br up
sudo ip link set dev veth1 up
sudo ip route append default via 192.168.0.1 dev veth1
sudo ip address delete 192.168.0.137/24 dev enp5s0
