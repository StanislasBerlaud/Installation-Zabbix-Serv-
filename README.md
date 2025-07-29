# Script d'installation de Zabbix sur Debian 12

Ce script Bash permet d’installer et de configurer **Zabbix 7.0** sur un serveur **Debian 12**. Il comprend l'installation de la base de données **MariaDB**, du serveur Zabbix, de l'interface web.

##  Fonctionnalités

- Mise à jour du système
- Configuration des locales `en_US.UTF-8` et `fr_FR.UTF-8` si absentes
- Installation de MariaDB
- Création de la base de données et de l'utilisateur Zabbix
- Installation du dépôt officiel Zabbix
- Installation des paquets nécessaires
- Import du schéma SQL
- Configuration du serveur Zabbix et de PHP
- Configuration d'Apache pour l'interface web
- Démarrage et activation des services

##  Prérequis

- Système Debian 12
- Accès `sudo`
- Connexion Internet active

##  Utilisation
Clonez ce dépôt ou téléchargez le script :
```bash
git clone https://github.com/StanislasBerlaud/Installation-Zabbix-Serv-.git
cd Installation-Zabbix-Serv-
```
Rendez le script exécutable :

```bash
chmod +x zabbixServ.sh
```
Lancez l’installation :

```bash
sudo ./zabbixServ.sh
```
Le script vous demandera un mot de passe pour l’utilisateur zabbix dans MariaDB. Assurez-vous de le retenir pour les futures configurations.

Une fois l’installation terminée, accédez à l’interface web Zabbix via :
```
http://[ADRESSE_IP_DU_SERVEUR]/zabbix
```

##  Sécurité
Le mot de passe saisi pour MariaDB n’est stocké nulle part en clair, mais il est utilisé temporairement dans le script.

Pensez à restreindre l’accès SSH et à changer les mots de passe par défaut après l’installation.
Par défaut, pour vous connecter, le nom d'utilisateur est Admin et le mot de passe est zabbix.


##  Personnalisation
Vous pouvez modifier :

- La version de Zabbix (lien .deb dans le script)
- La configuration d'Apache ou de PHP selon vos besoins


##  Fichiers modifiés par le script 

- /etc/zabbix/zabbix_server.conf

- /etc/php/8.2/apache2/php.ini

- /etc/apache2/conf-available/zabbix.conf

