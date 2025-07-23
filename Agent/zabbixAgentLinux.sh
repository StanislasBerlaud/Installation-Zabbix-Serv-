#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script en tant que root (utilisez sudo)"
    exit 1
fi

read -rp "Entrez l'adresse IP du serveur Zabbix : " ZABBIX_SERVER_IP

if [[ -z "$ZABBIX_SERVER_IP" ]]; then
    echo "L'adresse IP ne peut pas être vide."
    exit 1
fi

echo "Installation de l'agent Zabbix..."
apt update
apt install -y zabbix-agent

echo "Configuration de l'agent Zabbix..."

cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak

sed -i "s/^Server=.*/Server=$ZABBIX_SERVER_IP/" /etc/zabbix/zabbix_agentd.conf

if ! grep -q "^Server=" /etc/zabbix/zabbix_agentd.conf; then
    echo "Server=$ZABBIX_SERVER_IP" >> /etc/zabbix/zabbix_agentd.conf
fi

sudo chmod +x /etc/zabbix/zabbix_agentd.conf

echo "Démarrage et activation de l'agent..."
systemctl start zabbix-agent
systemctl enable zabbix-agent
systemctl restart zabbix-agent

echo "Agent Zabbix installé et configuré avec le serveur $ZABBIX_SERVER_IP"
