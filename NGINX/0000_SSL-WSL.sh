###########
# Windows #
###########

В файл c:\Windows\System32\Drivers\etc\hosts дописать домены

127.0.0.1    example.test
127.0.0.1    www.example.test
127.0.0.1    localhost
127.0.0.1    www.localhost

###############
# Power Shell #
###############

#от имени администратора
Win -> PowerShell

#накатываю менеджер пакетов chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#накатываю утилиту
choco install mkcert

#устанавливаю локальный центр сертификации
mkcert -install

#генерирую сертификаты

mkcert -cert-file C:\Users\Азъ\example.test-fullchain.pem -key-file C:\Users\Азъ\example.test-privkey.pem example.test
mkcert -cert-file C:\Users\Азъ\www.example.test-fullchain.pem -key-file C:\Users\Азъ\www.example.test-privkey.pem www.example.test
mkcert -cert-file C:\Users\Азъ\localhost-fullchain.pem -key-file C:\Users\Азъ\localhost-privkey.pem localhost
mkcert -cert-file C:\Users\Азъ\www.localhost-fullchain.pem -key-file C:\Users\Азъ\www.localhost-privkey.pem www.localhost
mkcert -cert-file C:\Users\Азъ\127.0.0.1-fullchain.pem -key-file C:\Users\Азъ\127.0.0.1-privkey.pem 127.0.0.1

#######
# WSL #
#######

#готовлю директории (пути как в продакшене)

sudo mkdir -p /etc/letsencrypt/live/example.test/
sudo mkdir -p /etc/letsencrypt/live/www.example.test/
sudo mkdir -p /etc/letsencrypt/live/localhost/
sudo mkdir -p /etc/letsencrypt/live/www.localhost/
sudo mkdir -p /etc/letsencrypt/live/127.0.0.1/

sudo chmod 777 /etc/letsencrypt/live/example.test/
sudo chmod 777 /etc/letsencrypt/live/www.example.test/
sudo chmod 777 /etc/letsencrypt/live/localhost/
sudo chmod 777 /etc/letsencrypt/live/www.localhost/
sudo chmod 777 /etc/letsencrypt/live/127.0.0.1/

#переношу сертификаты

sudo mv /mnt/c/Users/Азъ/example.test-fullchain.pem /etc/letsencrypt/live/example.test/fullchain.pem
sudo mv /mnt/c/Users/Азъ/example.test-privkey.pem /etc/letsencrypt/live/example.test/privkey.pem

sudo mv /mnt/c/Users/Азъ/www.example.test-fullchain.pem /etc/letsencrypt/live/www.example.test/fullchain.pem
sudo mv /mnt/c/Users/Азъ/www.example.test-privkey.pem /etc/letsencrypt/live/www.example.test/privkey.pem

sudo mv /mnt/c/Users/Азъ/localhost-fullchain.pem /etc/letsencrypt/live/localhost/fullchain.pem
sudo mv /mnt/c/Users/Азъ/localhost-privkey.pem /etc/letsencrypt/live/localhost/privkey.pem

sudo mv /mnt/c/Users/Азъ/www.localhost-fullchain.pem /etc/letsencrypt/live/www.localhost/fullchain.pem
sudo mv /mnt/c/Users/Азъ/www.localhost-privkey.pem /etc/letsencrypt/live/www.localhost/privkey.pem

sudo mv /mnt/c/Users/Азъ/127.0.0.1-fullchain.pem /etc/letsencrypt/live/127.0.0.1/fullchain.pem
sudo mv /mnt/c/Users/Азъ/127.0.0.1-privkey.pem /etc/letsencrypt/live/127.0.0.1/privkey.pem

#перезапускаю NGINX

sudo service nginx stop
sudo service nginx start

######################################
# для создания сертификатов на проде #
######################################

server {
        listen 80;
        listen [::]:80;
        server_name _;
        root /var/www/web;
        index index.html;
}
