#!/bin/bash

if [[ $# -ne 6 ]]; then
    echo "Utiliser le nombre exact d'arguments: $0 <container_name> <template> <network_address> <memory> <cpu> <root_password>"
    exit 1
fi

CONTAINER_NAME=$1
TEMPLATE=$2
NETWORK_ADDRESS=$3
MEMORY=$4
CPU=$5
ROOT_PASSWORD=$6

# Création du conteneur avec le template spécifié
echo "Création du conteneur $CONTAINER_NAME avec le template $TEMPLATE..."
sudo lxc-create -n $CONTAINER_NAME -t $TEMPLATE

if [[ $? -ne 0 ]]; then
    echo "Erreur lors de la création du conteneur."
    exit 1
fi

# Modification du fichier de configuration du conteneur
CONFIG_FILE="/var/lib/lxc/$CONTAINER_NAME/config"

echo "Modification de la configuration réseau..."
echo "lxc.net.0.type = veth" >> $CONFIG_FILE
echo "lxc.net.0.link = lxcbr0" >> $CONFIG_FILE
echo "lxc.net.0.flags = up" >> $CONFIG_FILE
echo "lxc.net.0.ipv4.address = $NETWORK_ADDRESS" >> $CONFIG_FILE

echo "Configuration de la mémoire et des CPU..."
echo "lxc.cgroup2.memory.max = ${MEMORY}M" >> $CONFIG_FILE
echo "lxc.cgroup2.cpuset.cpus = $CPU" >> $CONFIG_FILE

# Définition du mot de passe root
echo "Définition du mot de passe root..."
echo "root:$ROOT_PASSWORD" | sudo chroot /var/lib/lxc/$CONTAINER_NAME/rootfs chpasswd

echo "Conteneur $CONTAINER_NAME créé avec succès."
