echo "--- Démarrage de l'installation complète (Système + Docker + Zabbix) ---"

echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

sudo apt install -y curl git

if ! command -v docker &> /dev/null; then
    echo "Installation de Docker en cours..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installé avec succès."
else
    echo "Docker est déjà installé."
fi

echo "Lancement des conteneurs Zabbix..."
sudo docker compose up -d

echo "--- Installation terminée ! ---"
echo "Accédez à Zabbix sur : http://$(hostname -I | awk '{print $1}')"
