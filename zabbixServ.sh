sudo apt update && sudo apt upgrade -y

if ! command -v docker &> /dev/null; then
    echo "Installation de Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

echo "Lancement de Zabbix 7.0..."
sudo docker compose up -d

echo "Zabbix est prêt ! Accédez à http://localhost"
