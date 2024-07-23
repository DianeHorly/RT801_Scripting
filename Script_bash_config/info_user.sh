#!/bin/bash
# Récuperation des infos de l'user
user=$(whoami)                                           # Obtient le nom d'utilisateur

user_id=$(id -u "$user")                              # Obtient l'ID de l'utilisateur

groups=$(groups "$user")                          # Obtient la liste des groupes de l'utilisateur

# Création d'un nouveau fichier pour chaque utilisation(# Génère un nom de fichier unique basé sur la date et l'heure courantes)
timestamp=$(date +"%Y%m%d_%H%M%S")
filename="user_infoBash_${user}_${timestamp}.txt"

# Ecrit le infos dans le fichier

echo "Utilisateur: $user" > "$filename"
echo "ID de l'utilisateur: $user_id" >> "$filename"
echo "Groupe de l'utilisateur: $groups">> "$filename"

# Affichage des info sur l'user
echo " Affichage des infos sur l'utilisateur:"
echo "------------------------------------------------------------------------"
echo "Utilisateur :$user"
echo "ID de l'utilisateur: $user_id"
echo "Groupes de l'utilisateur: $groups"
echo "-------------------------------------------------------------------------"

#Vérifier si le fichier a été créé et affiche son contenu
if [ -f "$filename" ]; then
   echo "Contenu du fichier $filename: "
   cat "$filename"
else
   echo "Erreur: le fichier $filename n'a pas été créé ou est introuvable."

exit 0
