#!/bin/bash

# Ce script récupère des informations sur l'utilisateur courant et les enregistre dans un fichier.

# Définition du nom du fichier de sortie basé sur le nom de l'utilisateur courant
output_file=$(whoami).txt

# Récupération du nom de l'utilisateur courant
username=$(whoami)

# Récupération de l'ID de l'utilisateur courant
user_id=$(id -u)

# Récupération des groupes auxquels appartient l'utilisateur courant
user_groups=$(groups)

# Écriture des informations sur l'utilisateur dans le fichier de sortie
echo "Informations sur l'utilisateur :" >> "$output_file"
echo "Utilisateur: $username" >> "$output_file"
echo "ID de l'utilisateur: $user_id" >> "$output_file"
echo "Groupes de l'utilisateur: $user_groups" >> "$output_file"

# Affichage d'un message indiquant que les informations ont été enregistrées
echo "Les informations ont été enregistrées dans le fichier : $output_file"

# Fin du script avec un code de sortie 0 (succès)
exit 0
