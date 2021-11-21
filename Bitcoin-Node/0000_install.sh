##########################################
#                                        #
#    ФИНАНСОВЫЙ СЕРВЕР                   #
#                                        #
#    генерирует адреса для пополнений    #
#    принимает платежи                   #
#    отправляет выплаты                  #
#    отдаёт адреса для пополнений        #
#    отдаёт историю пополнений           #
#    отдаёт историю выплат               #
#                                        #
##########################################

#игнорировать закрытие крышки ноутбука
echo 'HandleLidSwitch=ignore' >> /etc/systemd/logind.conf
systemctl reboot

#питание от аккумулятора
apt install upower






############
# удобства #
############

#изменить конфиг баш
nano /root/.bashrc

alias power="/usr/bin/php7.4 /root/power.php;echo;"
alias btc-start-main="export MALLOC_ARENA_MAX=1;bitcoind -daemon -chain=main;"
alias btc-start-test="export MALLOC_ARENA_MAX=1;bitcoind -daemon -chain=test;"
alias btc-stop="bitcoin-cli -rpcuser=user -rpcpassword=password stop"
alias btc-info="bitcoin-cli -rpcuser=user -rpcpassword=password -getinfo | jq"
alias btc-disk="du -sh /root/.bitcoin/ --exclude=testnet3;[ -d '/root/.bitcoin/testnet3/' ] && du -sh /root/.bitcoin/testnet3/"





####################################
# ежедневное резервное копирование #
####################################

#файл скрипта
touch /root/backup.sh; chmod 777 /root/backup.sh; nano /root/backup.sh

#!/bin/bash
#текущая дата (пример 2021-12-31)
day=$(date +%F)
#что бэкапить
target="/root/.bitcoin/"
#куда бэкапить
backup="/root/$day.tar.gz"
#выполнение бэкапа (исключая поддиректорию testnet3)
tar cpzf $backup --exclude "${target}testnet3" $target
#удалить бэкапы старее 10 дней
find $backup* -mtime +10 -exec rm {} \;






#############
# веб-морда #
#############

#домен
nano /etc/nginx/sites-enabled/192.168.1.56

#домен биткоин-узла
server {
	server_name 192.168.1.56;

	root /var/www/web/;
	listen 80;

	add_header 'Cache-Control' 'private';
	expires 0;
	etag on;

	location ~ (/deposit-address-get.php|/deposit-address-create.php|/deposit-history-get.php|/withdraw-history-get.php) {
		#отдаётся только в браузеры вошедших пользователей
		add_header 'Access-Control-Allow-Origin' 'https://main.site';
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/run/php/php7.4-fpm.sock;
	}

	location /withdraw-order-add.php {
		#пока отдаётся только основному серверу
		#переделать: отдаётся только в браузеры вошедших пользователей
		allow 94.103.81.147;
		deny all;
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/run/php/php7.4-fpm.sock;
	}
}

#применить изменения
systemctl restart nginx

#узнать установленные модули
/usr/sbin/nginx -V 2>&1|xargs -n1|grep module






################
# Bitcoin Core #
################

wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz -O ~/bitcoin.tar.gz
cd ~/
mkdir bitcoin
tar -C ~/bitcoin -xvf bitcoin.tar.gz --strip-components 1
rm bitcoin.tar.gz
cd ~/bitcoin/bin/
mv bitcoind /usr/local/bin/bitcoind
mv bitcoin-cli /usr/local/bin/bitcoin-cli
cd ~/
rm -rf bitcoin
rm /root/.wget-hsts






# конфиг демона (test & main)
mkdir /root/.bitcoin/
nano /root/.bitcoin/bitcoin.conf

rpcthreads     = 4
rpcallowip     = 127.0.0.1
prune          = 551
maxmempool     = 200
par            = 1
dbcache        = 4
maxconnections = 11
addresstype    = p2sh-segwit
rpcuser        = user
rpcpassword    = password
[test]
wallet         = /root/.bitcoin/testnet3/wallets/wallet-test
rpcport        = 8332
rpcbind        = 127.0.0.1:8332
[main]
wallet         = /root/.bitcoin/wallet-main






#######################################################
# старт демона, создание кошелька (test), стоп демона #
#######################################################

bitcoind -daemon -chain=test
bitcoin-cli -rpcuser=user -rpcpassword=password createwallet wallet-test
bitcoin-cli -rpcuser=user -rpcpassword=password stop






#######################################################
# старт демона, создание кошелька (main), стоп демона #
#######################################################

bitcoind -daemon -chain=main
bitcoin-cli -rpcuser=user -rpcpassword=password createwallet wallet-main
bitcoin-cli -rpcuser=user -rpcpassword=password stop






###################
# создать таблицы #
###################

CREATE TABLE addresses (
    id         bigint                   not null    UNIQUE,
    address    character varying(64)    not null
);

CREATE TABLE deposits (
    time       character varying(16)     not null,
    hash       character varying(128)    not null    UNIQUE,
    amount     bigint                    not null,
    id         bigint                    not null,
    counted    boolean                   not null
);

CREATE TABLE withdraws (
    time       character varying(16)     not null,
    hash       character varying(128)    not null    UNIQUE,
    amount     bigint                    not null,
    address    character varying(64)     not null,
    #key       character varying(16)     not null,
    id         bigint                    not null,
    counted    boolean                   not null
);






########
# крон #
########

crontab -e

#заменить test@test.test своей почтой

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
HOME=/
MAILTO=test@test.test






##########
# чистка #
##########

#кэш установщика приложений
apt clean

#очистить историю команд пользователя Postgres и команд Psql
echo '' > /var/lib/postgresql/.psql_history
echo '' > /var/lib/postgresql/.bash_history

#мануалы
apt purge man
rm -rf /usr/share/doc/






########################################
#                                      #
#    ИТОГО                             #
#                                      #
#    запускать демона в нужной сети    #
#                                      #
########################################

bitcoin-cli -rpcuser=user -rpcpassword=password -getinfo | jq
bitcoin-cli -rpcuser=user -rpcpassword=password getnewaddress "MyLabel" "p2sh-segwit"
bitcoin-cli -rpcuser=user -rpcpassword=password stop
