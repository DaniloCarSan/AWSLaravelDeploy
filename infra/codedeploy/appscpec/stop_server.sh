#!/bin/bash

# Stop and disable PHP-FPM
sudo systemctl stop php-fpm

# Stop Nginx
sudo systemctl stop nginx