#!/bin/bash

# Pasta root do projeto
PROJECT_PATH_ROOT="/var/www/html/project"

# ------------------------------------------------------------------------------------------
# CONFIGURAÇÕES DO NGINX
# ------------------------------------------------------------------------------------------
sudo rm -f /etc/nginx/conf.d/default.conf
sudo cp $PROJECT_PATH_ROOT/infra/nginx/laravel.conf /etc/nginx/conf.d/laravel.conf

# ------------------------------------------------------------------------------------------
# CONFIGURAÇÕES DO PHP
# ------------------------------------------------------------------------------------------

# configuração do php.ini
sudo cp $PROJECT_PATH_ROOT/infra/php/php.ini /etc/php.ini
# Cria arquivo de log do PHP
sudo touch /var/log/php_errors.log  
sudo chown apache:apache /var/log/php_errors.log
sudo chmod 664 /var/log/php_errors.log
# Configuração do PHP-FPM
sudo cp $PROJECT_PATH_ROOT/infra/php/www.conf /etc/php-fpm.d/www.conf


# ------------------------------------------------------------------------------------------
# CONFIGURAÇÕES DE PERMISSÕES DAS PASTAS DO LARAVEL
# ------------------------------------------------------------------------------------------

# Configura permissões de propriedade para o usuário e grupo do Apache
sudo chown -R apache:apache $PROJECT_PATH_ROOT/storage
sudo chown -R apache:apache $PROJECT_PATH_ROOT/bootstrap/cache
sudo chown -R apache:apache $PROJECT_PATH_ROOT/database

# Configura permissões de escrita para o usuário e grupo
sudo chmod -R 775 $PROJECT_PATH_ROOT/storage
sudo chmod -R 775 $PROJECT_PATH_ROOT/bootstrap/cache
sudo chmod -R 775 $PROJECT_PATH_ROOT/database

# Configura permissões de grupo setgid para diretórios
find "$PROJECT_PATH_ROOT/storage" -type d -exec chmod g+s {} \;
find "$PROJECT_PATH_ROOT/bootstrap/cache" -type d -exec chmod g+s {} \;
find "$PROJECT_PATH_ROOT/database" -type d -exec chmod g+s {} \;

# ------------------------------------------------------------------------------------------
# CONFIGURAÇÕES DO LARAVEL
# ------------------------------------------------------------------------------------------
cd $PROJECT_PATH_ROOT

# ------------------------------------------------------------------------------------------
# CONFIGURAÇÕES DO DAS VARIÁVEIS DE AMBIENTE
# ------------------------------------------------------------------------------------------
chmod +x ./infra/get_parameter_store.sh

APP_ENV=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/APP_ENV")
APP_DEBUG=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/APP_DEBUG")
APP_KEY=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/APP_KEY")
APP_URL=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/APP_URL")
DB_CONNECTION=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/DB_CONNECTION")
DB_HOST=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/DB_HOST")
DB_PORT=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/DB_PORT")
DB_DATABASE=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/DB_DATABASE")
DB_USERNAME=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/DB_USERNAME")
DB_PASSWORD=$(./infra/get_parameter_store.sh "/LARAVEL_DEPLOY_AWS/DB_PASSWORD")

sudo sed -i 's/APP_ENV=.*/APP_ENV='"$APP_ENV"'/' .env
sudo sed -i 's/APP_DEBUG=.*/APP_DEBUG='"$APP_DEBUG"'/' .env
sudo sed -i 's/APP_KEY=.*/APP_KEY='"$APP_KEY"'/' .env
sudo sed -i 's|APP_URL=.*|APP_URL='"$APP_URL"'|' .env
sudo sed -i 's/DB_CONNECTION=.*/DB_CONNECTION='"$DB_CONNECTION"'/' .env
sudo sed -i 's/# DB_HOST=.*/DB_HOST='"$DB_HOST"'/' .env
sudo sed -i 's/# DB_PORT=.*/DB_PORT='"$DB_PORT"'/' .env
sudo sed -i 's/# DB_DATABASE=.*/DB_DATABASE='"$DB_DATABASE"'/' .env
sudo sed -i 's/# DB_USERNAME=.*/DB_USERNAME='"$DB_USERNAME"'/' .env
sudo sed -i 's/# DB_PASSWORD=.*/DB_PASSWORD='"$DB_PASSWORD"'/' .env

# ------------------------------------------------------------------------------------------
# CONFIGURAÇÕES DO CACHE DO LARAVEL
# ------------------------------------------------------------------------------------------
sudo php artisan config:cache
sudo php artisan route:cache
sudo php artisan view:cache
sudo php artisan event:cache