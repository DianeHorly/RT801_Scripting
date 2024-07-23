#!/bin/python3
import os
import pwd
import grp

 # Récupérer les informations sur l'utilisateur actuel
user_info = pwd.getpwuid(os.getuid())
user_name = user_info.pw_name
user_id = user_info.pw_uid
user_groups = [grp.getgrgid(g).gr_name for g in os.getgroups()]



# Récupérer les informations sur l'utilisateur
#user_name, user_id, user_groups = get_user_info()

# Afficher les informations
print("Nom de l'utilisateur:", user_name)
print("ID de l'utilisateur:", user_id)
print("Groupes de l'utilisateur:", user_groups)

# Enregistrer les informations dans un nouveau fichier avec le nom de l'utilisateur
filename = user_name + "_info.txt2"
with open(filename, "a") as file:
 file.write("Nom de l'utilisateur: {}\n".format(user_name))
 file.write("ID de l'utilisateur: {}\n".format(user_id))
 file.write("Groupes de l'utilisateur: {}\n".format(", ".join(user_groups)))

exit(0)
