1.) пора в закрытый репозиторий, ибо задолбало париться с не публичными данными
2.) статику сюда?
3.) на нём хранить истории пополнений и выплат - позволит слать ключи подтверждения выплат
4.) пополнения добавлять по старинке - по туннелю: транзакционно брать последнее пополнение и добавлять платежи новее него
5.) выплаты выполнять - по одной и использовать пару чекпоинт-файлов (на bitcoin-node и auth) для этого, ну или по туннелю транзакционно

######################################
#                                    #
#    СЕРВЕР АУТЕНТИФИКАЦИИ           #
#                                    #
#    хранит user_id, email, login    #
#    отправляет письма с паролями    #
#    выдаёт токены авторизации       #
#                                    #
######################################



#############
# веб-морда #
#############

#домен
nano /etc/nginx/sites-enabled/v859140.hosted-by-vdsina.ru

server {
        server_name v859140.hosted-by-vdsina.ru;

        ssl_certificate     /etc/letsencrypt/live/v859140.hosted-by-vdsina.ru/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/v859140.hosted-by-vdsina.ru/privkey.pem;

        listen 443 ssl http2;
        listen [::]:443 ssl http2 ipv6only=on;

        root /var/www/web/;

        add_header 'Cache-Control' 'private';
        expires 0;
        etag off;

        location /auth.php {
                add_header 'Access-Control-Allow-Origin' 'https://main.site';
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }

        location ~ (/deposit-address-get.php|/deposit-address-create.php|/deposit-history-get.php|/withdraw-history-get.php) {
                #отдаётся только в браузеры вошедших пользователей
                add_header 'Access-Control-Allow-Origin' 'https://main.site';
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }

        location /withdraw-order-add.php {
                #пока отдаётся только основному серверу
                #переделать: отдаётся только в браузеры вошедших пользователей
                #allow 94.103.81.147;
                #deny all;
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }
}

#применить изменения
systemctl restart nginx
