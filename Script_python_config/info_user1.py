#!/usr/local/bin/python3

import os
import datetime

#Récuperation des infos sur l'utilisateur
username= os.getlogin()
user_id= os.getuid()
user_groups= os.popen('groups').read().strip()

# géneration d'un  fichier 
datestap = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
file_sortie = ("user_infoTp2_recu_{}.txt".format(username))

#ecrire les infos dans le fichier de sortie
with open(file_sortie,"w") as f:
  f.write("info sur l'utilisateur: \n")
  f.write("-----------------------------------------------------------")
  f.write("Utilisateur: {}\n".format(username))
  f.write("ID de l'utilisateur:{}\n".format(user_id))
  f.write("Groupes de l'utilisateur: {}\n".format(user_groups))

print("Information enregidtrées dans {}".format(file_sortie))

exit(0)
