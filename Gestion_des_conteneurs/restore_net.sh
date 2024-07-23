#!/bin/bash

BRIDGE_NAME="lxcbr0"

# Désactivation de l'IP forwarding
echo "Désactivation de l'IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=0

# Suppression de la règle NAT
echo "Suppression de la règle NAT..."
sudo iptables -t nat -D POSTROUTING -s 172.25.47.62/20 ! -d 172.25.47.62/20 -j MASQUERADE

# Désactivation du bridge
echo "Désactivation du bridge $BRIDGE_NAME..."
sudo ip link set $BRIDGE_NAME down

# Suppression du bridge
sudo brctl delbr $BRIDGE_NAME

echo "Bridge $BRIDGE_NAME supprimé et configuration réseau restaurée."
