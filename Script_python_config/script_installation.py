#!/bin/python3

import os
import shutil

archive_name = input("Nom de l'archive : ")
install_dir = input("Répertoire de base d'installation : ")

# Vérification de l'existence de l'archive et des droits
if not os.path.exists(archive_name):
        print("L'archive spécifiée n'existe pas.")
        exit (1)
if not os.access(archive_name, os.R_OK):
        print("Vous n'avez pas les droits de l ecture sur l'archive.")
        exit (1)
if not os.path.exists(install_dir):
        print("Le répertoire d'installation spécifié n'existe pas.")
        exit (1)
if not os.access(install_dir, os.W_OK):
        print("Vous n'avez pas les droits d'écriture dans le répertoire d'installation.")
        exit (1)

# Tester le type d'archive en fonction de l'extension
if archive_name.endswith('.zip'):
        shutil.unpack_archive(archive_name, install_dir)
elif archive_name.endswith('.tar'):
        shutil.unpack_archive(archive_name, extract_dir=install_dir)
elif archive_name.endswith('.tgz') or archive_name.endswith('.tar.gz'):
        shutil.unpack_archive(archive_name, extract_dir=install_dir)
else:
        print("Type d'archive non pris en charge.")

exit (0)
