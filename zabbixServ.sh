#!/bin/bash

echo "Lancement de l'installation de Zabbix"

echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y
apt install apache2


echo "Configuration des locales en_US.UTF-8 et fr_FR.UTF-8"


if ! locale -a | grep -q "en_US.UTF-8"; then
    echo "Ajout de la locale en_US.UTF-8..."
    sudo sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
fi

if ! locale -a | grep -q "fr_FR.UTF-8"; then
    echo "Ajout de la locale fr_FR.UTF-8..."
    sudo sed -i 's/^# *\(fr_FR.UTF-8 UTF-8\)/\1/' /etc/locale.gen
fi

echo "Génération des locales..."
sudo locale-gen


echo "Installation de MariaDB..."
sudo apt install mariadb-server -y

echo "Création de la base de données Zabbix"

while true; do
    read -s -p "Entrez le mot de passe pour l'utilisateur Zabbix pour la base de données : " mdp
    echo
    read -s -p "Confirmez le mot de passe : " mdp_confirm
    echo

    if [ "$mdp" = "$mdp_confirm" ]; then
        break
    else
        echo "Les mots de passe ne correspondent pas. Veuillez réessayer."
    fi
done


sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE OR REPLACE USER 'zabbix'@'localhost' IDENTIFIED BY '${mdp}';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Téléchargement du dépôt Zabbix..."
wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_7.0-1+debian12_all.deb

echo "Installation du dépôt Zabbix..."
sudo dpkg -i zabbix-release_7.0-1+debian12_all.deb
sudo apt update

echo "Installation des paquets Zabbix..."
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent zabbix-sql-scripts -y

echo "Importation du schéma de la base de données Zabbix..."
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -u zabbix -p"$mdp" zabbix

echo "Configuration de zabbix_server.conf..."
CONF_FILE="/etc/zabbix/zabbix_server.conf"
sudo cp "$CONF_FILE" "${CONF_FILE}.bak"

sudo sed -i "s/^DBHost=.*/DBHost=localhost/" "$CONF_FILE"
sudo sed -i "s/^DBName=.*/DBName=zabbix/" "$CONF_FILE"
sudo sed -i "s/^DBUser=.*/DBUser=zabbix/" "$CONF_FILE"

if grep -q "^DBPassword=" "$CONF_FILE"; then
    sudo sed -i "s/^DBPassword=.*/DBPassword=$mdp/" "$CONF_FILE"
else
    echo "DBPassword=$mdp" | sudo tee -a "$CONF_FILE" > /dev/null
fi

echo "Configuration PHP requise pour zabbix..."
PHP_INI="/etc/php/8.2/apache2/php.ini"
sudo cp "$PHP_INI" "${PHP_INI}.bak"

sudo sed -i "s/^post_max_size.*/post_max_size = 16M/" "$PHP_INI"
sudo sed -i "s/^upload_max_filesize.*/upload_max_filesize = 2M/" "$PHP_INI"
sudo sed -i "s/^max_execution_time.*/max_execution_time = 300/" "$PHP_INI"
sudo sed -i "s/^max_input_time.*/max_input_time = 300/" "$PHP_INI"

grep -q "^post_max_size" "$PHP_INI" || echo "post_max_size = 16M" | sudo tee -a "$PHP_INI" > /dev/null
grep -q "^upload_max_filesize" "$PHP_INI" || echo "upload_max_filesize = 2M" | sudo tee -a "$PHP_INI" > /dev/null
grep -q "^max_execution_time" "$PHP_INI" || echo "max_execution_time = 300" | sudo tee -a "$PHP_INI" > /dev/null
grep -q "^max_input_time" "$PHP_INI" || echo "max_input_time = 300" | sudo tee -a "$PHP_INI" > /dev/null

echo "Configuration d'Apache pour l'interface web Zabbix..."
APACHE_CONF="/etc/apache2/conf-available/zabbix.conf"
sudo tee "$APACHE_CONF" > /dev/null <<EOL
Alias /zabbix /usr/share/zabbix
<Directory /usr/share/zabbix>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
EOL

sudo a2enconf zabbix

echo "Redémarrage des services..."
sudo systemctl restart apache2
sudo systemctl restart zabbix-server zabbix-agent
sudo systemctl enable apache2 zabbix-server zabbix-agent

echo "Installation terminée."
echo "Accédez à l'interface web : http://$(hostname -I | awk '{print $1}')/zabbix"
