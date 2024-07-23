#!/usr/local/bin/python3

# Ce script collecte les informations sur l'uptime, la charge mémoire et CPU, 
# l'occupation des partitions et les processus les plus gourmands en CPU et mémoire.

import psutil  # Bibliothèque pour l'accès aux informations sur le système et les processus
import os  # Bibliothèque pour les opérations sur le système d'exploitation
import time  # Bibliothèque pour la gestion du temps
import json  # Bibliothèque pour la manipulation des données JSON

def collect_data():
    data = {}
    
    # Uptime (temps écoulé depuis le dernier démarrage)
    with open('/proc/uptime', 'r') as f:
        uptime = f.readline().split()[0]
        data['uptime'] = float(uptime)
    
    # Charge mémoire et CPU
    data['memory'] = psutil.virtual_memory()._asdict()  # Informations sur la mémoire
    data['cpu'] = psutil.cpu_percent(interval=1)  # Pourcentage d'utilisation du CPU
    
    # Utilisation des disques
    data['disk'] = {part.mountpoint: psutil.disk_usage(part.mountpoint)._asdict() for part in psutil.disk_partitions()}
    
    # Top 3 des processus les plus gourmands en CPU
    processes = sorted(psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent']),
                       key=lambda proc: proc.info['cpu_percent'], reverse=True)[:3]
    data['top_cpu_processes'] = [proc.info for proc in processes]
    
    # Top 3 des processus les plus gourmands en mémoire
    processes = sorted(psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent']),
                       key=lambda proc: proc.info['memory_percent'], reverse=True)[:3]
    data['top_memory_processes'] = [proc.info for proc in processes]
    
    return data

def save_data(data, filename):
    # Enregistrement des données collectées dans un fichier JSON
    with open(filename, 'w') as f:
        json.dump(data, f, indent=4)

if __name__ == "__main__":
    data = collect_data()  # Collecte des données
    timestamp = time.strftime("%Y%m%d%H%M%S")  # Génération d'un timestamp pour le nom du fichier
    filename = f"/root/supervision_{timestamp}.json"  # Définition du nom du fichier de sortie
    save_data(data, filename)  # Sauvegarde des données dans le fichier
