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
# настройка демона                          #
# важна длина обрезки цепи (551 или больше) #
# важен абсолютный путь до DataDir          #
#############################################

nano ~/bitcoin-prune-551/bitcoin.conf

#секция тестовой сети
[test]
par         = 1
datadir     = /home/ku/bitcoin-prune-551/
addresstype = p2sh-segwit
chain       = test
rpcuser     = user
rpcpassword = password
rpcport     = 8332
rpcallowip  = 127.0.0.1
rpcbind     = 127.0.0.1:8332

####################################
# старт демона                     #
# важен абсолютный путь до DataDir #
####################################

bitcoind -daemon -chain=test -prune=551 -datadir=/home/ku/bitcoin-prune-551

###############
# стоп демона #
###############

bitcoin-cli -rpcuser=user -rpcpassword=password stop
