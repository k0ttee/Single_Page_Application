######################################
#                                    #
#    СЕРВЕР АУТЕНТИФИКАЦИИ           #
#                                    #
#    хранит user_id, email, login    #
#    отправляет письма с паролями    #
#    выдаёт токены авторизации       #
#                                    #
######################################






############
# удобства #
############

#переименовать сервер (заменить auth своим названием)
hostnamectl set-hostname auth
hostnamectl

#добавить имя в хосты
echo '127.0.0.1 auth' >> /etc/hosts

#изменить конфиг баш
nano /root/.bashrc

PS1="${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
alias grep="grep --color=auto"
alias ls="ls --color"
alias disk="df -H / && echo && df -i /"

#подхватить конфиг баш
source /root/.bashrc






###########
# утилиты #
###########

apt install htop jq -y






########################
# файл подкачки (1 gb) #
########################

fallocate -l 1024M /swapfile
chmod 600 /swapfile
/sbin/mkswap /swapfile
/sbin/swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

#применение
/sbin/sysctl -p
systemctl daemon-reload






#######################################
# веб-морда, база данных, свои демоны #
#######################################

apt install nginx -y
apt install php-fpm php-mbstring php-pgsql -y
apt install postgresql pgbouncer -y






#############
# веб-морда #
#############

#домен
nano /etc/nginx/sites-enabled/192.168.1.2

#домен узла аутентификации
server {
        server_name 192.168.1.2;

        root /var/www/web/;
        listen 80;

        add_header 'Cache-Control' 'private';
        expires 0;
        etag off;

        location /auth.php {
                add_header 'Access-Control-Allow-Origin' 'https://main.site';
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }
}

#применить изменения
systemctl restart nginx






################
# создать базу #
################

su postgres
cd ~/
psql

#какие базы есть
\l

#создать базу
CREATE DATABASE auth;
\c auth

#какие таблицы есть
\d






###################
# создать таблицы #
###################

#пользователи, почты, ники, рефоводы
CREATE TABLE users (
    id           BIGSERIAL                 NOT NULL    UNIQUE,
    email        character varying(255)    NOT NULL    UNIQUE,
    nick_name    character varying(16)                 UNIQUE,
    invite       bigint
);

#одноразовые пароли, языки писем, отправленность одноразовых паролей
CREATE TABLE passwords (
    id          BIGINT                   NOT NULL    UNIQUE,
    password    character varying(16)    NOT NULL,
    lang        character varying(2)     NOT NULL,
    send        boolean                  NOT NULL
);

#ключи выплат, языки писем, отправленность ключей выплат
CREATE TABLE keys (
    id      BIGINT                   NOT NULL    UNIQUE,
    key     character varying(16)    NOT NULL,
    lang    character varying(2)     NOT NULL,
    send    boolean                  NOT NULL
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

#мануалы
apt purge man
rm -rf /usr/share/doc/






#########################################
#                                       #
#    ИТОГО                              #
#                                       #
#    запускать демона рассылки писем    #
#                                       #
#########################################