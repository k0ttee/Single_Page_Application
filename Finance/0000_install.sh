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
# запуск демона                             #
# важна длина обрезки цепи (551 или больше) #
#############################################

bitcoind -daemon -prune=551 -datadir=~/bitcoin-prune-551
