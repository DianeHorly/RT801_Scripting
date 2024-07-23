#!/bin/bash

# Vérifie si au moins un argument est passé au script
if [[ $# -lt 1 ]]; then
    # Affiche un message d'erreur et indique comment utiliser le script
    echo "Utiliser le nombre d'arguments nécessaires: $0 <container_name_pattern>"
    # Quitte le script avec un code de sortie 1 (échec)
    exit 1
fi

# Stocke le premier argument dans la variable PATTERN
PATTERN=$1

# Boucle sur chaque nom de conteneur qui correspond au motif (PATTERN)
for CONTAINER in $(sudo lxc-ls -1 | grep -E "$PATTERN"); do
    # Affiche un message indiquant que le conteneur va être arrêté
    echo "Arrêt du conteneur $CONTAINER..."
    # Tente d'arrêter le conteneur avec lxc-stop
    sudo lxc-stop -n $CONTAINER
    # Vérifie si la commande précédente a échoué (code de sortie différent de 0)
    if [[ $? -ne 0 ]]; then
        # Affiche un message d'erreur si l'arrêt du conteneur a échoué
        echo "Erreur lors de l'arrêt du conteneur $CONTAINER."
    else
        # Affiche un message de succès si l'arrêt du conteneur a réussi
        echo "Conteneur $CONTAINER arrêté avec succès."
    fi
done
