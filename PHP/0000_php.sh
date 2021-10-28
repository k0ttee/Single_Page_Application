#сессии в оперативке
echo 'tmpfs /ramsessions tmpfs noatime,nodiratime,nodev,nosuid,size=64M 0 0' >> /etc/fstab
echo 'session.save_path = "/ramsessions"' >> /etc/php/7.4/fpm/php.ini
