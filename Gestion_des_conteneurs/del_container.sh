#!/bin/bash

# Vérifie si au moins un argument est passé au script
if [ $# -lt 1 ]; then
    # Affiche un message d'erreur et indique comment utiliser le script
    echo "Utiliser le nombre d'arguments nécessaires: $0 <container_name_pattern>"
    # Quitte le script avec un code de sortie 1 (échec)
    exit 1
fi

# Stocke le premier argument dans la variable PATTERN
PATTERN=$1

# Boucle sur chaque nom de conteneur qui correspond au motif (PATTERN)
for CONTAINER in $(sudo lxc-ls -1 | grep -E "$PATTERN"); do
    # Affiche un message indiquant que le conteneur va être détruit
    echo "Destruction du conteneur $CONTAINER..."
    # Tente de détruire le conteneur avec lxc-destroy
    sudo lxc-destroy -n $CONTAINER
    # Vérifie si la commande précédente a échoué (code de sortie différent de 0)
    if [ $? -ne 0 ]; then
        # Affiche un message d'erreur si la destruction du conteneur a échoué
        echo "Erreur lors de la destruction du conteneur $CONTAINER."
    else
        # Affiche un message de succès si la destruction du conteneur a réussi
        echo "Conteneur $CONTAINER détruit avec succès."
    fi
done
