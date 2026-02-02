INSTALL_DIR="zabbix-docker"
REPO_URL="https://github.com/StanislasBerlaud/Installation-Zabbix-Serv-.git"

echo "Installation sécurisée de Zabbix 7.0 (Docker)"

sudo apt update && sudo apt install -y git curl openssl
if ! command -v docker &> /dev/null; then
    echo "Docker non trouvé, installation en cours..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installé."
fi

if [ -d "$INSTALL_DIR" ]; then
    echo "Mise à jour du dossier existant..."
    cd $INSTALL_DIR && git pull
else
    echo "Clonage du dépôt..."
    git clone -b docker $REPO_URL $INSTALL_DIR
    cd $INSTALL_DIR
fi

if [ ! -f .env ]; then
    echo ""
    echo "CONFIGURATION DES MOTS DE PASSE"
    
    while true; do
        echo -n "Choisissez le mot de passe pour l'utilisateur DB 'zabbix' : "
        read -s DB_PASS
        echo ""
        echo -n "Confirmez le mot de passe : "
        read -s DB_PASS_CONFIRM
        echo ""
        
        if [ -n "$DB_PASS" ] && [ "$DB_PASS" == "$DB_PASS_CONFIRM" ]; then
            break
        else
            echo "Erreur : Les mots de passe ne correspondent pas ou sont vides. Réessayez."
        fi
    done

    while true; do
        echo -n "Choisissez le mot de passe pour l'administrateur 'root' : "
        read -s ROOT_PASS
        echo ""
        echo -n "Confirmez le mot de passe root : "
        read -s ROOT_PASS_CONFIRM
        echo ""
        
        if [ -n "$ROOT_PASS" ] && [ "$ROOT_PASS" == "$ROOT_PASS_CONFIRM" ]; then
            break
        else
            echo "Erreur : Les mots de passe root ne correspondent pas ou sont vides. Réessayez."
        fi
    done

    echo "MYSQL_DATABASE=zabbix" > .env
    echo "MYSQL_USER=zabbix" >> .env
    echo "MYSQL_PASSWORD=$DB_PASS" >> .env
    echo "MYSQL_ROOT_PASSWORD=$ROOT_PASS" >> .env
    echo "Fichier .env généré localement."
else
    echo "Le fichier .env existe déjà, utilisation des paramètres actuels."
fi


echo "Lancement des conteneurs Zabbix..."
sudo docker compose up -d

echo "INSTALLATION TERMINÉE AVEC SUCCÈS !"
echo "URL : http://$(hostname -I | awk '{print $1}')"
echo "Login par défaut : Admin"
echo "Password par défaut : zabbix"
echo "Note : Vos mots de passe DB sont sauvegardés dans $(pwd)/.env"
