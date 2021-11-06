#вход в рута
sudo -i

#обновления
apt update
apt upgrade

#утилиты
apt install htop -y
apt install curl -y
apt install wget -y
apt install jq -y

#веб
apt install nginx -y

#пхп
apt install php-fpm -y
apt install php7.4-mbstring -y
apt install php7.4-pgsql -y
apt install php7.4-gd -y

#база
apt install postgresql -y
apt install pgbouncer -y

#почта
#маил-утил и опен-дким и ещё что-то?

#биткоин
#поискать репозиторий

#лайткоин
#есть в репозиториях

#чистка
apt clean

#выход из рута
exit
