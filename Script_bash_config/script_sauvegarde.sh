#!/bin/bash

# Vérification des paramètres
if [ $# -ne 5 ]; then
    echo "Utiliser le nombre d'argument nécessaire pour le script: $0 <nom_archive> <repertoire_a_sauvegarder> <adresse_serveur_sauvegarde> <login> <password>"
    exit 1
fi

# Assignation des paramètres
archive_name="$1"
backup_directory="$2"
server_address="$3"
login="$4"
password="$5"

# Vérification de l'existence du répertoire à sauvegarder
if [ ! -d "$backup_directory" ]; then
    echo "Erreur: Le répertoire à sauvegarder n'existe pas."
    exit 1
fi

# Création de l'archive avec tar
echo "Création de l'archive $archive_name ..."
tar -czf "$archive_name.tar.gz" "$backup_directory"

# Copie de l'archive à travers du réseau via SFTP
echo "Copie de l'archive à $server_address via SFTP ..."
# Utilisation de l'outil expect pour automatiser l'authentification SFTP avec le mot de passe
expect -c "
spawn sftp $login@$server_address
expect \"password:\"
send \"$password\r\"
expect \"sftp>\"
send \"put $archive_name.tar.gz\r\"
expect \"sftp>\"
send \"exit\r\"
interact
"

echo "La sauvegarde a été réalisée avec succès."

exit 0