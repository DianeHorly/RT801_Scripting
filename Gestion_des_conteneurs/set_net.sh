#!/bin/bash

BRIDGE_NAME="lxcbr0"

# Création du bridge
echo "Création du bridge $BRIDGE_NAME..."
sudo brctl addbr $BRIDGE_NAME

# Activation du bridge
sudo ip link set dev $BRIDGE_NAME up

# Configuration du bridge avec une adresse IP
#sudo ip addr add 10.0.3.1/24 dev $BRIDGE_NAME
sudo ip addr flush dev eth0

# Configuration de NAT
echo "Configuration de NAT..."
sudo iptables -t nat -A POSTROUTING -s 172.25.47.62/20 ! -d 172.25.47.62/20 -j MASQUERADE

# Activation de l'IP forwarding
echo "Activation de l'IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

echo "Bridge $BRIDGE_NAME configuré avec succès."

