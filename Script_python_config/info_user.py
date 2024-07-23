#!/usr/local/bin/python3
import subprocess
import datetime

def get_user_info():
    # Obtient le nom d'utilisateur
    username = subprocess.check_output(['whoami']).decode().strip()

    # Obtient l'ID de l'utilisateur
    uid = int(subprocess.check_output(['id', '-u', username]).decode().strip())

    # Obtient la liste des groupes de l'utilisateur
    groups = subprocess.check_output(['groups', username]).decode().strip().split()

    return username, uid, groups

def save_user_info():
    # Récupère les informations sur l'utilisateur
    username, uid, groups = get_user_info()

    # Génère un nom de fichier unique basé sur la date et l'heure courantes
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = "user_info_{}.txt".format(username)

    # Écrit les informations dans le fichier
    with open(filename, 'w') as file:
        file.write("Utilisateur : {}\n".format(username))
        file.write("ID Utilisateur : {}\n".format(uid))
        file.write("Groupes :\n")
        for group in groups:
            file.write("- {}\n".format(group))

    print("Informations enregistrées dans : {}".format(filename))

if __name__ == "__main__":
    save_user_info()
