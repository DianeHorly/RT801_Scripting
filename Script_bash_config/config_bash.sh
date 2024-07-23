#!/bin/bash
if [ $# -ne 5 ]; then
    echo "Le nombre de paramètre doit atteindre 5"
    exit 1
fi

hote=$1
id_carte_reseau=$2
addr_carte_reseau=$3
addr_passerelle=$4
addr_dns=$5

# 1. Affectation du nom d'hôte
echo "affectation: $hote"
hostname $hote
if [ $? -ne 0 ]; then
  echo "Erreur: Impossible de définir le nom d'hôte."
  exit 1
fi

# 2. Vérification de lexistence de linterface réseau
if [ ! -e "/sys/class/net/$id_carte_reseau" ]; then
  echo "Erreur: L'interface réseau $interface_reseau n'existe pas."
  exit 1
fi

# 3. Désactivation de la carte réseau
echo "Désactivation de l'interface réseau: $id_carte_reseau"
ip link set dev $id_carte_reseau down
if [ $? -ne 0 ]; then
  echo "Erreur: Impossible de désactiver l'interface réseau."
  exit 1
fi

# 4. Modification de l'adresse de la carte réseau
echo "Configuration de l'adresse IP: $addr_carte_reseau"
ip addr add $addr_carte_reseau dev $id_carte_reseau
if [ $? -ne 0 ]; then
  echo "Erreur: Impossible de configurer l'adresse IP."
  exit 1
fi

# 5. Activation de l'interface réseau et du service réseau (si nécessaire)
echo "Activation de l'interface réseau: $id_carte_reseau"
ip link set dev $id_carte_reseau up
if [ $? -ne 0 ]; then
  echo "Erreur: Impossible d'activer l'interface réseau."
  exit 1
fi

# Vérification si le service réseau est activé (ex: systemd-networkd)
if systemctl status systemd-networkd > /dev/null 2>&1; then
  echo "Activation du service réseau: systemd-networkd"
  systemctl start systemd-networkd
  if [ $? -ne 0 ]; then
    echo "Erreur: Impossible d'activer le service réseau."
    exit 1
  fi
fi

# 6. Modification de l'adresse du DNS
echo "Configuration du DNS: $addr_dns"
echo "$addr_dns" > /etc/resolv.conf
if [ $? -ne 0 ]; then
  echo "Erreur: Impossible de configurer le DNS."
  exit 1
fi
# 7. Test de connexion au réseau
echo "Test de connexion au réseau..."
ping -c 3 $addr_passerelle
if [ $? -ne 0 ]; then
  echo "Erreur: Impossible de se connecter au réseau."
  exit 1
fi

echo "Configuration terminée avec succès."

exit 0
