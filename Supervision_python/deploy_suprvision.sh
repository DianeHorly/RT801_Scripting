#!/usr/local/bin/python3

# Ce script crée les conteneurs, déploie les sondes, programme 
# les tâches cron pour les exécuter périodiquement et configure le serveur web.

#!/bin/bash

# Variables
CONTAINERS=("C1" "C2" "C3")
IMAGES=("debian" "debian" "debian")
IPS=("10.0.3.2" "10.0.3.3" "10.0.3.4")
MEMORY=512
CPU=1
PASSWORD="password"

# Fonction pour créer et démarrer un conteneur
create_and_start_container() {
    local name=$1
    local image=$2
    local ip=$3
    ./creat_container.sh $name $image $ip $MEMORY $CPU $PASSWORD
    ./start_container.sh $name
}

# Création et démarrage des conteneurs
for i in ${!CONTAINERS[@]}; do
    create_and_start_container ${CONTAINERS[$i]} ${IMAGES[$i]} ${IPS[$i]}
done

# Déploiement des sondes et configuration sur C2 et C3
for container in C2 C3; do
    sudo lxc-attach -n $container -- apt update
    sudo lxc-attach -n $container -- apt install -y python3-pip
    sudo lxc-attach -n $container -- pip3 install psutil
    sudo lxc-attach -n $container -- mkdir -p /root
    sudo lxc-file push sonde_containers.py $container/root/sonde_containers.py
    sudo lxc-attach -n $container -- bash -c 'echo "*/5 * * * * python3 /root/sonde_containers.py" | crontab -'
done

# Configuration du centralisateur sur C1
sudo lxc-attach -n C1 -- apt update
sudo lxc-attach -n C1 -- apt install -y python3-pip
sudo lxc-attach -n C1 -- pip3 install flask
sudo lxc-attach -n C1 -- mkdir -p /root
sudo lxc-file push centralize.py C1/root/centralize.py

# Démarrage du serveur web sur C1
sudo lxc-attach -n C1 -- bash -c 'nohup python3 /root/centralize.py &'

# Affichage des IP des conteneurs pour accéder au serveur web
echo "Le serveur web de supervision est disponible à l'adresse http://10.0.3.2:5000/"
