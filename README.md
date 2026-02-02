# Installation Zabbix 7.0 (Docker) sur Raspberry Pi / Debian

Ce projet permet de déployer une solution de supervision **Zabbix 7.0 LTS** en quelques minutes sur un Raspberry Pi 5 ou un serveur Debian 12, en utilisant **Docker**.

L'installation est entièrement automatisée, sécurisée et isolée dans des conteneurs.

## Fonctionnalités

- **Installation automatique** de Docker et Docker Compose (si absents).
- Déploiement de la stack complète :
  - **Zabbix Server 7.0** (Alpine Linux)
  - **Interface Web** (Apache + PHP)
  - **Base de données** (MariaDB)
- **Sécurité renforcée** : Les mots de passe de la base de données sont demandés lors de l'installation et stockés uniquement en local dans un fichier `.env`.

## Installation Rapide (One-Liner)

Ouvrez un terminal sur votre machine et lancez simplement cette commande :

```bash
curl -sSL https://raw.githubusercontent.com/StanislasBerlaud/Installation-Zabbix-Serv-/docker/install.sh | bash
```
Le script va :

Mettre à jour votre système.

Installer Docker (si nécessaire).

Vous demander de définir vos mots de passe sécurisés.

Lancer les services Zabbix.

Accès à l'interface
Une fois l'installation terminée, ouvrez votre navigateur :

URL : http://<ADRESSE_IP>

Utilisateur par défaut : Admin (Attention au 'A' majuscule)

Mot de passe par défaut : zabbix

Note : Au premier lancement, la base de données peut prendre 30 à 60 secondes pour s'initialiser.

Gestion du serveur
Les commandes utiles pour gérer votre serveur Zabbix :

Voir l'état des conteneurs :

```Bash

cd zabbix-docker
sudo docker compose ps
```
Arrêter le serveur :

```Bash

sudo docker compose stop
```
Redémarrer le serveur :

```Bash

sudo docker compose up -d
```
Reset général :

```Bash

cd zabbix-docker
sudo docker compose down -v
```

Désinstallation complète :

```Bash

cd ~/zabbix-docker
sudo docker compose down -v

sudo docker image prune -a -f

cd ~
sudo rm -rf zabbix-docker
```
Vos mots de passe (DB User et Root) sont stockés localement dans le fichier .env à la racine du dossier d'installation.

Données : Les données de supervision sont stockées dans un volume Docker persistant.

Prérequis :

Un système Debian 12 ou Raspberry Pi OS (Bookworm) et une connexion internet.
