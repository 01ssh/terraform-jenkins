#!/bin/bash
sudo apt-get update
yes | sudo apt install openjdk-11-jdk-headless
echo "Waiting for 30 seconds before installing the jenkins package..."
sleep 30
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
yes | sudo apt-get install jenkins
sleep 30
echo "Waiting for 30 seconds before installing the Terraform..."
wget https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_386.zip
yes | sudo apt-get install unzip
unzip 'terraform*.zip'
sudo mv terraform /usr/local/bin/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo apt install unzip
sudo unzip awscliv2.zip
sudo ./aws/install
aws --version
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
helm version --client

# Téléchargez la version la plus récente de kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Rendez le fichier binaire exécutable
sudo chmod +x ./kubectl

# Déplacez le fichier binaire dans votre PATH
sudo mv ./kubectl /usr/local/bin/kubectl

# Vérifiez l'installation
kubectl version --client


# Téléchargez et installez eksctl via curl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

# Déplacez le binaire eksctl dans votre PATH
sudo mv /tmp/eksctl /usr/local/bin

# Vérifiez l'installation
eksctl version


# Mettez à jour le cache des packages et installez les dépendances pour ajouter un repository via HTTPS
sudo apt update
# Installez le package software-properties-common
sudo apt update && sudo apt install -y software-properties-common

# Ajoutez le dépôt Docker à votre liste de sources APT
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee -a /etc/apt/sources.list

# Importez la clé GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Mettez à jour à nouveau le cache des packages maintenant que le dépôt Docker est ajouté
sudo apt update

# Installez Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io


# Ajoutez votre utilisateur au groupe docker pour exécuter des commandes Docker sans sudo
sudo usermod -aG docker $USER

# Activez les changements de groupe Docker sans déconnexion/reconnexion
newgrp docker

# Vérifiez l'installation en lançant un conteneur témoin
docker --version

sudo systemctl start docker
sudo systemctl enable docker

mkdir terminé

sudo su  - jenkins

#eksctl create cluster --name my-little-eks --region eu-west-3 --nodegroup-name my-nodes --node-type t3.small --managed --nodes 2 


