#!/bin/bash

# Vérification que le nombre de paramètres est correct
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <archive_name> <installation_directory>"
    exit 1
fi

# Affectation des paramètres à des variables
ARCHIVE_NAME=$1
INSTALL_DIR=$2

# Vérification de l'existence de l'archive
if [[ ! -f $ARCHIVE_NAME ]]; then
    echo "L'archive $ARCHIVE_NAME n'existe pas."
    exit 1
fi

# Vérification de l'existence du répertoire d'installation
if [[ ! -d $INSTALL_DIR ]]; then
    echo "Le répertoire $INSTALL_DIR n'existe pas. Création du répertoire."
    mkdir -p "$INSTALL_DIR"
    if [[ $? -ne 0 ]]; then
        echo "Erreur lors de la création du répertoire $INSTALL_DIR."
        exit 1
    fi
fi

# Vérification des droits d'écriture dans le répertoire d'installation
if [[ ! -w $INSTALL_DIR ]]; then
    echo "Vous n'avez pas les droits d'écriture dans le répertoire $INSTALL_DIR."
    exit 1
fi

# Détermination du type d'archive en fonction de l'extension
case "$ARCHIVE_NAME" in
    *.zip)
        echo "L'archive est de type ZIP."
        unzip "$ARCHIVE_NAME" -d "$INSTALL_DIR"
        if [[ $? -ne 0 ]]; then
            echo "Erreur lors de l'extraction de l'archive ZIP."
            exit 1
        fi
        ;;
    *.tar)
        echo "L'archive est de type TAR."
        tar -xf "$ARCHIVE_NAME" -C "$INSTALL_DIR"
        if [[ $? -ne 0 ]]; then
            echo "Erreur lors de l'extraction de l'archive TAR."
            exit 1
        fi
        ;;
    *.tgz | *.tar.gz)
        echo "L'archive est de type TGZ/TAR.GZ."
        tar -xzf "$ARCHIVE_NAME" -C "$INSTALL_DIR"
        if [[ $? -ne 0 ]]; then
            echo "Erreur lors de l'extraction de l'archive TGZ/TAR.GZ."
            exit 1
        fi
        ;;
    *)
        echo "Type d'archive non supporté. Seuls les fichiers ZIP, TAR, et TGZ sont supportés."
        exit 1
        ;;
esac

echo "Extraction réussie dans le répertoire $INSTALL_DIR."

exit 0
