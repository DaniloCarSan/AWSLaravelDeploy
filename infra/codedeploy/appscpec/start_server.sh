#!/bin/bash

# Restart e habilitação do PHP-FPM
sudo systemctl restart php-fpm
sudo systemctl enable php-fpm

# Reinicialização e habilitação do Nginx
sudo systemctl enable nginx
sudo systemctl restart nginx