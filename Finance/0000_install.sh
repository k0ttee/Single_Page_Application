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






###########
# утилиты #
###########

apt install wget curl htop jq -y





########################################
# веб сервер, база данных, свои демоны #
########################################

apt install nginx -y
apt install php-fpm php-mbstring php-pgsql -y
apt install postgresql pgbouncer -y






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
nano ~/bitcoin-prune-600/bitcoin.conf

[test]

par         = 1
prune       = 600
datadir     = /root/bitcoin-prune-600/
wallet      = /root/bitcoin-prune-600/testnet3/wallets/wallet-test/
addresstype = p2sh-segwit
rpcthreads  = 1
chain       = test
rpcuser     = user
rpcpassword = password
rpcport     = 8332
rpcallowip  = 127.0.0.1
rpcbind     = 127.0.0.1:8332

[main]

par         = 1
prune       = 600
datadir     = /root/bitcoin-prune-600/
wallet      = /root/bitcoin-prune-600/wallet-main/
addresstype = p2sh-segwit
rpcthreads  = 1
chain       = main
rpcuser     = user
rpcpassword = password
rpcport     = 8332
rpcallowip  = 127.0.0.1
rpcbind     = 127.0.0.1:8332






#######################################################
# старт демона, создание кошелька (test), стоп демона #
#######################################################

bitcoind -daemon -chain=test -prune=600 -datadir=/root/bitcoin-prune-600/
bitcoin-cli -rpcuser=user -rpcpassword=password createwallet wallet-test
bitcoin-cli -rpcuser=user -rpcpassword=password stop






#######################################################
# старт демона, создание кошелька (main), стоп демона #
#######################################################

bitcoind -daemon -chain=main -prune=600 -datadir=/root/bitcoin-prune-600/
bitcoin-cli -rpcuser=user -rpcpassword=password createwallet wallet-main
bitcoin-cli -rpcuser=user -rpcpassword=password stop






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
