#!/bin/bash

echo "=========================== libnss3-tools ==========================="
REQUIRED_PKG="libnss3-tools"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")
echo "Checking for $REQUIRED_PKG: $PKG_OK"
if [ "" = "$PKG_OK" ]; then
    echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
    sudo apt install -y $REQUIRED_PKG
fi

echo "=========================== mkcert ==========================="
COMMAND_NAME="mkcert"
if ! command -v $COMMAND_NAME &>/dev/null; then
    echo "$COMMAND_NAME could not be found. Setting up $COMMAND_NAME."

    # shellcheck disable=SC2164
    cd ~/
    wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
    sudo mv mkcert-v1.4.3-linux-amd64 mkcert
    sudo chmod +x mkcert
    sudo cp mkcert /usr/local/bin/

    mkcert -install
    mkdir /var/www/certs
    mkdir /var/www/logs
    mkcert -cert-file /var/www/certs/localhost.pem -key-file /var/www/certs/localhost-key.pem localhost
    sudo chmod 777 /etc/apache2/sites-enabled/*
    sudo systemctl reload apache2
else
    echo "$COMMAND_NAME install ok installed"
fi