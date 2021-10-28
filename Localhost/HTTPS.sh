#######
# WSL #
#######

#готовлю директории (пути как в продакшене)
sudo mkdir -p /etc/letsencrypt/live/localhost/
sudo chmod 777 /etc/letsencrypt/live/localhost/

#добавляю зависимость
sudo apt install libnss3-tools

#подтаскиваю утилиту (дока к ней https://github.com/FiloSottile/mkcert)
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.2/mkcert-v1.4.2-linux-amd64
mv mkcert-v1.4.2-linux-amd64 mkcert
chmod +x mkcert
sudo mv mkcert /usr/local/bin/

#создаю локальный центр сертификации (покрывает адреса example.com *.example.com example.test localhost 127.0.0.1 ::1)
#mkcert -install

#sudo mkcert -cert-file /etc/letsencrypt/live/localhost/fullchain.pem -key-file /etc/letsencrypt/live/localhost/privkey.pem localhost

###############
# Power Shell #
###############

Win -> PowerShell -> запуск от имени администратора

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install mkcert
mkcert -install
setx CAROOT “$(mkcert -CAROOT)”; If ($Env:WSLENV -notlike “*CAROOT*”) { setx WSLENV “CAROOT/up:$Env:WSLENV” }

#######
# WSL #
#######

mkcert -CAROOT
#/home/ku/.local/share/mkcert

sudo mv /home/ku/.local/share/mkcert/rootCA.pem /etc/letsencrypt/live/localhost/fullchain.pem
sudo mv /home/ku/.local/share/mkcert/rootCA-key.pem /etc/letsencrypt/live/localhost/privkey.pem

###############
# Power Shell #
###############

mkcert localhost 127.0.0.1 ::1 0.0.0.0
