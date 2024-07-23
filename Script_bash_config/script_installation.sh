#!/bin/bash

# Vérification des paramètres
if [ $# -ne 2 ]; then
    echo "Utiliser le nombre de parametres nécessaire: $0 <nom_archive> <repertoire_base_installation>"
    exit 1
fi

# Assignation des paramètres
archive_name="$1"
installation_directory="$2"

# Vérification de l'existence du répertoire de base d'installation
if [ ! -d "$installation_directory" ]; then
    echo "Erreur: Le répertoire de base d'installation n'existe pas."
    exit 1
fi

# Vérification des droits d'accès sur le répertoire de base d'installation
if [ ! -r "$installation_directory" ] || [ ! -x "$installation_directory" ]; then
    echo "Erreur: Vous n'avez pas les droits nécessaires sur le répertoire de base d'installation."
    exit 1
fi

# Extraction de l'extension de l'archive
extension="${archive_name##*.}"

# Test du type d'archive
case "$extension" in
    zip)
        echo "Décompression de l'archive ZIP..."
        unzip -q "$archive_name" -d "$installation_directory"
        ;;
    tar|gz|tgz)
        echo "Décompression de l'archive tar.gz/tgz..."
        tar -xzf "$archive_name" -C "$installation_directory"
        ;;
    *)
        echo "Erreur: Type d'archive non supporté."
        exit 1
        ;;
esac

echo "Opération terminée avec succès."
