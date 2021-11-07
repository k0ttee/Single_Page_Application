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





#утилиты
apt install wget curl htop jq






#php
#






##########################
# установка Bitcoin Core #
# важна версия в ссылке  #
##########################

wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz -O ~/bitcoin.tar.gz
cd ~/
mkdir bitcoin
tar -C ~/bitcoin -xvf bitcoin.tar.gz --strip-components 1
rm bitcoin.tar.gz
cd ~/bitcoin/bin/
sudo mv bitcoind /usr/local/bin/bitcoind
sudo mv bitcoin-cli /usr/local/bin/bitcoin-cli
cd ~/
rm -rf bitcoin






#############################################
# настройка демона (test & main)            #
# важна длина обрезки цепи (551 или больше) #
# важен абсолютный путь до DataDir          #
#############################################

nano ~/bitcoin-prune-551/bitcoin.conf

[test]

par         = 1
prune       = 551
datadir     = /home/ku/bitcoin-prune-551/
#wallet      = /home/ku/bitcoin-prune-551/testnet3/wallets/wallet-test/
addresstype = p2sh-segwit
rpcthreads  = 2
chain       = test
rpcuser     = user
rpcpassword = password
rpcport     = 8332
rpcallowip  = 127.0.0.1
rpcbind     = 127.0.0.1:8332

[main]

par         = 1
prune       = 551
datadir     = /home/ku/bitcoin-prune-551/
#wallet      = /home/ku/bitcoin-prune-551/wallet-main/
addresstype = p2sh-segwit
rpcthreads  = 2
chain       = main
rpcuser     = user
rpcpassword = password
rpcport     = 8332
rpcallowip  = 127.0.0.1
rpcbind     = 127.0.0.1:8332






####################################
# старт демона                     #
# важен абсолютный путь до DataDir #
####################################

#test
bitcoind -daemon -chain=test -prune=551 -datadir=/home/ku/bitcoin-prune-551/
#main
bitcoind -daemon -chain=main -prune=551 -datadir=/home/ku/bitcoin-prune-551/






###############
# стоп демона #
###############

bitcoin-cli -rpcuser=user -rpcpassword=password stop






###########################
# создание файла кошелька #
###########################

#test
bitcoin-cli -rpcuser=user -rpcpassword=password createwallet wallet-test
#main
bitcoin-cli -rpcuser=user -rpcpassword=password createwallet wallet-main

#после создания - раскомментировать пути в конфиге bitcoin.conf






########################
# управление кошельком #
########################

bitcoin-cli -rpcuser=user -rpcpassword=password -getinfo | jq

bitcoin-cli -rpcuser=user -rpcpassword=password getnewaddress "MyLabel" "p2sh-segwit"
