import os
import tarfile
import paramiko
import sys

# Vérification que le nombre d'arguments est correct
if len(sys.argv) != 6:
    print("Utiliser le nombre d'argumente nécessaire pour le script: <archive_name> <directory_to_backup> <backup_server> <login> <password>")
    sys.exit(1)

# Affectation des arguments à des variables
archive_name = sys.argv[1]
directory_to_backup = sys.argv[2]
backup_server = sys.argv[3]
login = sys.argv[4]
password = sys.argv[5]

# Création de l'archive tar gzippée
try:
    with tarfile.open(archive_name, "w:gz") as tar:
        tar.add(directory_to_backup, arcname=os.path.basename(directory_to_backup))
    print(f"Archive {archive_name} créée avec succès.")
except Exception as e:
    print(f"Erreur lors de la création de l'archive: {e}")
    sys.exit(1)

# Transfert de l'archive vers le serveur SFTP
try:
    # Connexion au serveur SFTP
    transport = paramiko.Transport((backup_server, 22))
    transport.connect(username=login, password=password)
    
    # Création du client SFTP
    sftp = paramiko.SFTPClient.from_transport(transport)
    
    # Transfert de l'archive
    sftp.put(archive_name, archive_name)
    
    # Fermeture de la connexion SFTP
    sftp.close()
    transport.close()
    
    print(f"Archive {archive_name} transférée avec succès.")
except Exception as e:
    print(f"Erreur lors du transfert de l'archive: {e}")
    sys.exit(1)
    
exit(0)    
