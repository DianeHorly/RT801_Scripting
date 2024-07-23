#!/bin/bash

# Suppression des packages installés
echo "Suppression des packages LXC et bridge-utils..."
sudo apt-get remove --purge -y lxc lxc-templates bridge-utils

# Nettoyage des dépendances non utilisées
sudo apt-get autoremove -y

# Nettoyage du cache apt
sudo apt-get clean

echo "Packages supprimés et environnement nettoyé."
