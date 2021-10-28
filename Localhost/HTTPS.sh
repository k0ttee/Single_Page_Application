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

mkcert -cert-file C:\Users\Азъ\localhost-fullchain.pem -key-file C:\Users\Азъ\localhost-privkey.pem localhost
mkcert -cert-file C:\Users\Азъ\127.0.0.1-fullchain.pem -key-file C:\Users\Азъ\127.0.0.1-privkey.pem 127.0.0.1
mkcert -cert-file C:\Users\Азъ\192.168.1.1-fullchain.pem -key-file C:\Users\Азъ\192.168.1.1-privkey.pem 192.168.1.1

#######
# WSL #
#######

#готовлю директории (пути как в продакшене)

sudo mkdir -p /etc/letsencrypt/live/localhost/
sudo mkdir -p /etc/letsencrypt/live/127.0.0.1/
sudo mkdir -p /etc/letsencrypt/live/192.168.1.1/

sudo chmod 777 /etc/letsencrypt/live/localhost/
sudo chmod 777 /etc/letsencrypt/live/127.0.0.1/
sudo chmod 777 /etc/letsencrypt/live/192.168.1.1/

#переношу сертификаты

sudo mv /mnt/c/Users/Азъ/localhost-fullchain.pem /etc/letsencrypt/live/localhost/fullchain.pem
sudo mv /mnt/c/Users/Азъ/localhost-privkey /etc/letsencrypt/live/localhost/privkey.pem

sudo mv /mnt/c/Users/Азъ/127.0.0.1-fullchain.pem /etc/letsencrypt/live/127.0.0.1/fullchain.pem
sudo mv /mnt/c/Users/Азъ/127.0.0.1-privkey /etc/letsencrypt/live/127.0.0.1/privkey.pem

sudo mv /mnt/c/Users/Азъ/192.168.1.1-fullchain.pem /etc/letsencrypt/live/192.168.1.1/fullchain.pem
sudo mv /mnt/c/Users/Азъ/192.168.1.1-privkey /etc/letsencrypt/live/192.168.1.1/privkey.pem
