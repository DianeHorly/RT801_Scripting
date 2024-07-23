#!/bin/bash

# Ce script ajoute les chemins des fichiers/répertoires à un fichier de liste de synchronisation.

# Définition du chemin vers le fichier de liste de synchronisation.
SYNC_LIST="/var/lib/lxc/sync_list.txt"

# Vérifie si le nombre d'arguments est inférieur à 2.
# Si c'est le cas, affiche un message d'utilisation et quitte avec un code de sortie 1 (erreur).
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <container> <path>"
    exit 1
fi

# Assigne le premier argument à la variable CONTAINER.
CONTAINER=$1

# Assigne le deuxième argument à la variable PATH.
PATH=$2

# Ajoute une entrée au fichier de liste de synchronisation dans le format "CONTAINER:PATH".
echo "$CONTAINER:$PATH" >> $SYNC_LIST

# Affiche un message confirmant l'ajout du chemin du conteneur à la liste de synchronisation.
echo "Ajouté $PATH du conteneur $CONTAINER à la liste de synchronisation."

exit(0)