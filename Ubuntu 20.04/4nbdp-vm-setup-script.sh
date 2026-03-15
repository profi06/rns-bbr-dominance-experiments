#!/usr/bin/env bash

# IPs
IPC1="192.168.0.7"
IPE1="192.168.0.220"
IPE2="192.168.0.3"
IPR1="192.168.0.167"
IPR2="192.168.0.52"
IPS1="192.168.0.28"

CAPACITY=100 #mbit
OWD=20 #ms
NBDP=4
BUFFER="$(python3 -c "print(int(1000 * $NBDP * $CAPACITY * 2 * $OWD / 8))")"

echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsDvIE1e0ntb7ylVWRiTqocB48PaTeshji72kYnY79V berechner06@berechner06 > ~/.ssh/authorized_keys

if [[ "$1" == "client" ]]; then
    IFACE1=enp8s0
    # Configure Addesses
    sudo ip addr add 10.0.1.1/24 dev $IFACE1
    sudo ip route add 10.0.3.0/24 via $IPE1
    sudo sysctl -w net.ipv4.ip_forward=1
    # Install stuff
    sudo apt update
    sudo apt -y install iperf3 moreutils ssh
    sudo modprobe tcp_bbr

elif [[ "$1" == "emulator" ]]; then
    IFACE1=enp8s0
    IFACE2=enp9s0
    # Configure Addesses
    sudo ip addr add 10.0.1.2/24 dev $IFACE1
    sudo ip addr add 10.0.2.1/24 dev $IFACE2
    sudo ip route add 10.0.3.0/24 via $IPR1
    sudo sysctl -w net.ipv4.ip_forward=1
    # Install stuff
    sudo apt update
    sudo apt -y install ssh
    # Setup delay at emulator
    sudo tc qdisc replace dev $IFACE1 root netem delay ${OWD}ms limit 60000
    sudo tc qdisc replace dev $IFACE2 root netem delay ${OWD}ms limit 60000


elif [[ "$1" == "router" ]]; then
    IFACE1=enp1s0
    IFACE2=enp7s0
    # Configure Addesses
    sudo ip addr add 10.0.2.2/24 dev $IFACE1
    sudo ip addr add 10.0.3.2/24 dev $IFACE2
    sudo ip route add 10.0.1.0/24 via $IPE2
    sudo sysctl -w net.ipv4.ip_forward=1
    # Install stuff
    sudo apt update
    sudo apt -y install moreutils jq ssh
    # Setup bottleneck at router
    sudo tc qdisc del dev $IFACE2 root
    sudo tc qdisc replace dev $IFACE2 root handle 1: htb default 3 
    sudo tc class add dev $IFACE2 parent 1: classid 1:3 htb rate ${CAPACITY}mbit 
    sudo tc qdisc add dev $IFACE2 parent 1:3 handle 3: bfifo limit $BUFFER 
    
elif [[ "$1" == "server" ]]; then
    IFACE1=enp1s0
    # Configure Addesses
    sudo ip addr add 10.0.3.1/24 dev $IFACE1
    sudo ip route add 10.0.1.0/24 via $IPR2
    sudo sysctl -w net.ipv4.ip_forward=1
    # Install stuff
    sudo apt update
    sudo apt -y install iperf3 moreutils ssh
    
fi;
