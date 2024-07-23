#!/bin/bash

# Ce script synchronise les fichiers et répertoires listés dans le fichier de liste de synchronisation.

# Définition des chemins des fichiers de liste de synchronisation et de log.
SYNC_LIST="/var/lib/lxc/sync_list.txt"
LOG_FILE="/var/lib/lxc/sync_log.txt"

# Définition des adresses IP des conteneurs.
C1_IP="10.0.3.2"
C2_IP="10.0.3.3"
C3_IP="10.0.3.4"

# Vérifie si le fichier de liste de synchronisation existe.
# Si ce n'est pas le cas, affiche un message d'erreur et quitte avec un code de sortie 1 (erreur).
if [[ ! -f $SYNC_LIST ]]; then
    echo "Aucun fichier de synchronisation trouvé."
    exit 1
fi

# Ajoute une entrée au fichier de log indiquant le début de la synchronisation.
echo "Début de la synchronisation : $(date)" >> $LOG_FILE

# Lit le fichier de liste de synchronisation ligne par ligne.
while IFS=: read -r CONTAINER PATH; do
    # Détermine l'adresse IP du conteneur en fonction de son nom.
    case $CONTAINER in
        C2) 
            CONTAINER_IP=$C2_IP 
            ;;
        C3) 
            CONTAINER_IP=$C3_IP 
            ;;
        *)
            echo "Conteneur non reconnu : $CONTAINER"
            continue
            ;;
    esac

    # Vérifie si le fichier/répertoire existe sur le serveur (C1) et récupère sa date de modification.
    if sudo lxc-attach -n C1 -- test -e "$PATH"; then
        SERVER_FILE_DATE=$(sudo lxc-attach -n C1 -- stat -c %Y "$PATH")
    else
        SERVER_FILE_DATE=0
    fi

    # Vérifie si le fichier/répertoire existe sur le conteneur client et récupère sa date de modification.
    if sudo lxc-attach -n $CONTAINER -- test -e "$PATH"; then
        CLIENT_FILE_DATE=$(sudo lxc-attach -n $CONTAINER -- stat -c %Y "$PATH")
    else
        CLIENT_FILE_DATE=0
    fi

    # Synchronisation des fichiers/répertoires en fonction des dates de modification.
    if [[ $SERVER_FILE_DATE -eq 0 && $CLIENT_FILE_DATE -eq 0 ]]; then
        # Si le fichier/répertoire n'existe ni sur le serveur ni sur le conteneur, log cette information.
        echo "Fichier/répertoire non trouvé sur $CONTAINER et serveur." >> $LOG_FILE
    elif [[ $SERVER_FILE_DATE -gt $CLIENT_FILE_DATE ]]; then
        # Si le fichier/répertoire sur le serveur est plus récent, copie vers le conteneur.
        echo "Copie de $PATH de serveur vers $CONTAINER." >> $LOG_FILE
        sudo lxc-attach -n C1 -- cp -r "$PATH" "/mnt/$CONTAINER/$PATH"
    elif [[ $CLIENT_FILE_DATE -gt $SERVER_FILE_DATE ]]; then
        # Si le fichier/répertoire sur le conteneur est plus récent, copie vers le serveur.
        echo "Copie de $PATH de $CONTAINER vers serveur." >> $LOG_FILE
        sudo lxc-attach -n $CONTAINER -- cp -r "$PATH" "/mnt/C1/$PATH"
    else
        # Si les fichiers/répertoires sont à jour des deux côtés, log cette information.
        echo "Le fichier/répertoire $PATH est déjà à jour sur $CONTAINER." >> $LOG_FILE
    fi

done < $SYNC_LIST

# Ajoute une entrée au fichier de log indiquant la fin de la synchronisation.
echo "Synchronisation terminée : $(date)" >> $LOG_FILE

exit 0