INSTALL_DIR="zabbix-docker"

echo "Préparation de l'installation automatique..."

sudo apt update && sudo apt install -y git curl
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

if [ -d "$INSTALL_DIR" ]; then
    echo "Le dossier $INSTALL_DIR existe déjà. Mise à jour..."
    cd $INSTALL_DIR && git pull
else
    git clone https://github.com/StanislasBerlaud/Installation-Zabbix-Serv-.git $INSTALL_DIR
    cd $INSTALL_DIR
fi

sudo docker compose up -d

echo "Accès : http://$(hostname -I | awk '{print $1}')"
