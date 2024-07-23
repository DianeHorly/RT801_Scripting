#!/bin/bash

# Mise à jour et installation des packages nécessaires
echo "Mise à jour des packages et installation des outils nécessaires..."
sudo apt-get update --fix-missing
sudo apt-get install -y lxc lxc-templates bridge-utils

# Vérification de l'installation
if [ $? -ne 0 ]; then
    echo "Erreur lors de l'installation des packages."
    exit 1
fi

echo "Installation des packages réussie."