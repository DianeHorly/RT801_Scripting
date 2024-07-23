#Ce script exécute un exemple de synchronisation depuis la machine hôte.

#!/bin/bash

# Chemins des scripts
ADD_TO_SYNC_LIST="add_to_sync_list.sh"
SYNC_FILES="sync_files.sh"

# Création des conteneurs C1, C2, C3
./creat_container.sh C1 debian 10.0.3.2 512 1 password
./creat_container.sh C2 debian 10.0.3.3 512 1 password
./creat_container.sh C3 debian 10.0.3.4 512 1 password

# Démarrage des conteneurs
./start_container.sh C1 C2 C3

# Ajout de répertoires/fichiers à la liste de synchronisation
./$ADD_TO_SYNC_LIST C2 /path/to/sync
./$ADD_TO_SYNC_LIST C3 /path/to/sync

# Exécution de la synchronisation
./$SYNC_FILES

# Affichage de l'état de la synchronisation sur C2 et C3
echo "État de la synchronisation sur C2 :"
sudo lxc-attach -n C2 -- ls -l /path/to/sync
echo "État de la synchronisation sur C3 :"
sudo lxc-attach -n C3 -- ls -l /path/to/sync

# Arrêt des conteneurs
cd Gestion_des_conteneurs/./stop_container.sh C1 C2 C3

# Suppression des conteneurs
cd Gestion_des_conteneurs/./del_container.sh C1 C2 C3
