#!/usr/bin/env bash

# IPs
IPC1="192.168.0.7"
IPE1="192.168.0.220"
IPE2="192.168.0.3"
IPR1="192.168.0.167"
IPR2="192.168.0.52"
IPS1="192.168.0.28"

CLIENT="-i robuste_vernetzte_systeme vboxuser@$IPC1"
EMULATOR="-i robuste_vernetzte_systeme vboxuser@$IPE1"
ROUTER="-i robuste_vernetzte_systeme vboxuser@$IPR1"
SERVER="-i robuste_vernetzte_systeme vboxuser@$IPS1"

mkdir $1

scp $CLIENT:"~/*-ss.txt" $1
scp $CLIENT:"~/bbr-result-*.json" $1
scp $ROUTER:"~/queue-*.txt" $1
