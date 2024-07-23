#!/usr/local/bin/python3

# Ce script récupère les fichiers JSON des sondes des conteneurs C2 et C3 
# et génère des pages HTML pour afficher les données.

import os  # Bibliothèque pour les opérations sur le système d'exploitation
import json  # Bibliothèque pour la manipulation des données JSON
from flask import Flask, render_template_string  # Flask pour le serveur web, render_template_string pour générer les pages HTML

app = Flask(__name__)  # Initialisation de l'application Flask

def load_data():
    # Cette fonction charge les fichiers JSON de supervision depuis le répertoire /root
    data_files = [f for f in os.listdir('/root') if f.startswith('supervision_') and f.endswith('.json')]
    data = {}
    for file in data_files:
        with open(f'/root/{file}', 'r') as f:
            timestamp = file.split('_')[1].split('.')[0]  # Extraction du timestamp depuis le nom de fichier
            data[timestamp] = json.load(f)  # Chargement des données JSON dans un dictionnaire
    return data

@app.route("/")
def index():
    # Route principale qui génère la page HTML à partir des données JSON
    data = load_data()
    return render_template_string(TEMPLATE, data=data)

# Modèle HTML pour l'affichage des données de supervision
TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Supervision</title>
</head>
<body>
    <h1>Supervision des Conteneurs</h1>
    {% for timestamp, info in data.items() %}
    <h2>Data Collected at: {{ timestamp }}</h2>
    <h3>Uptime: {{ info.uptime }} seconds</h3>
    <h3>CPU Load: {{ info.cpu }}%</h3>
    <h3>Memory Usage:</h3>
    <pre>{{ info.memory }}</pre>
    <h3>Disk Usage:</h3>
    <pre>{{ info.disk }}</pre>
    <h3>Top 3 CPU Processes:</h3>
    <pre>{{ info.top_cpu_processes }}</pre>
    <h3>Top 3 Memory Processes:</h3>
    <pre>{{ info.top_memory_processes }}</pre>
    {% endfor %}
</body>
</html>
'''

if __name__ == "__main__":
    # Lancement du serveur web Flask sur l'adresse 0.0.0.0 et le port 5000
    app.run(host='0.0.0.0', port=5000)
