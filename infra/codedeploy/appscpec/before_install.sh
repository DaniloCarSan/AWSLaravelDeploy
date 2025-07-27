#!/bin/bash

sudo yum update -y

# Instalação de dependências do nginx
sudo yum clean metadata
sudo yum install -y nginx

# Instalação de dependências do PHP
sudo yum install -y php php-fpm php-pdo php-mysqlnd php-mbstring php-xml php-bcmath php-curl php-zip php-cli php-gd
