echo "--- Déploiement de Zabbix via Docker ---"

if ! command -v docker &> /dev/null; then
    echo "Erreur : Docker n'est pas installé. Utilisez full_install.sh à la place."
    exit 1
fi

echo "Lancement de docker-compose..."
sudo docker compose up -d

echo "Supervision démarrée."
echo "URL : http://$(hostname -I | awk '{print $1}')"
