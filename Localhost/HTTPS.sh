###############
# Power Shell #
###############

Win -> PowerShell -> запуск от имени администратора

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install mkcert
mkcert -install
mkcert -cert-file C:\Users\Азъ\fullchain.pem -key-file C:\Users\Азъ\privkey.pem localhost

#######
# WSL #
#######

#готовлю директории (пути как в продакшене)
sudo mkdir -p /etc/letsencrypt/live/localhost/
sudo chmod 777 /etc/letsencrypt/live/localhost/

sudo mv /mnt/c/Users/Азъ/fullchain.pem /etc/letsencrypt/live/localhost/fullchain.pem
sudo mv /mnt/c/Users/Азъ/privkey.pem /etc/letsencrypt/live/localhost/privkey.pem

