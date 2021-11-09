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






############
# удобства #
############

#изменить конфиг баш
nano /root/.bashrc

PS1="${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
alias grep="grep --color=auto"
alias ls="ls -Fa --color"
alias ll="ls -l --color"
alias disk="df -H / && echo && df -i /"

#подхватить конфиг баш
source /root/.bashrc






###########
# утилиты #
###########

apt install wget curl htop jq -y





#######################################
# веб-морда, база данных, свои демоны #
#######################################

apt install nginx -y
apt install php-fpm php-mbstring php-pgsql -y
apt install postgresql pgbouncer -y






#веб-морда
nano /etc/nginx/sites-enabled/192.168.1.56

#веб-морда биткоин-узла
server {
        server_name 192.168.1.56;
        root /var/www;

        listen 80;

        index index.php;

        location / {
                expires 0;
                etag off;
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }
}

#применить изменения
systemctl restart nginx






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
mkdir ~/bitcoin-prune-600/





# конфиг демона (test & main)
mkdir /root/.bitcoin/
nano /root/.bitcoin/bitcoin.conf

par         = 1
prune       = 600
addresstype = p2sh-segwit
rpcuser     = user
rpcpassword = password
rpcallowip  = 127.0.0.1
[test]
wallet      = /root/.bitcoin/testnet3/wallets/wallet-test
rpcport     = 8332
rpcbind     = 127.0.0.1:8332
[main]
wallet      = /root/.bitcoin/wallet-main






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






########################
# файл подкачки (8 gb) #
########################

fallocate -l 8192M /swapfile
chmod 600 /swapfile
/sbin/mkswap /swapfile
/sbin/swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

#применение
/sbin/sysctl -p
systemctl daemon-reload






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

apt clean






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
