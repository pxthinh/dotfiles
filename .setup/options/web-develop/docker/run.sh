#!/bin/bash

echo "=========================== docker ==========================="
COMMAND_NAME="docker"
if ! command -v $COMMAND_NAME &>/dev/null; then
    echo "$COMMAND_NAME could not be found. Setting up $COMMAND_NAME."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt update
    apt-cache policy docker-ce
    sudo apt install docker-ce -y

    sudo usermod -aG docker ${USER}
    su - ${USER}+
    id -nG
    docker

    echo 'Install docker compose:'
    echo 'Check new version at https://github.com/docker/compose/releases'
    DOCKER_COMPOSE_VERSION=v2.9.0
    sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose

    REBOOT_TIME=3
    echo ""
    echo "After installing docker, you need to reboot to make sure the features work properly. Rebooting in $REBOOT_TIME seconds."
    sudo shutdown -r $REBOOT_TIME
    echo "If you do not want to reboot, please press 'shutdown -c' to cancel the reboot. If you want to reboot now, please press 'shutdown -r now'."
    while true; do
        read -p "Do you want to reboot now? (Y/N)  " yn
        case $yn in
        [Yy]*)
            sudo shutdown -r now
            break
            ;;
        [Nn]*) break ;;
        *) echo "Please answer yes or no." ;;
        esac
    done
else
    echo "$COMMAND_NAME install ok installed"
fi
echo ""
