sudo crontab -l > /home/ec2-user/ct.txt
sudo crontab -r
sudo service php-fpm stop
sudo service nginx stop
sleep 1
sudo service nginx stop
sudo mkdir /mnt/sdg
sudo mkfs.ext4 -N 9830400 /dev/sdg
sudo mount /dev/sdg /mnt/sdg
sudo rsync -az --exclude='swapfile' --exclude='*-prod_cache/*' --exclude='*tmp/*' --progress /opt/data1/ /mnt/sdg
sudo umount -f /opt/data1/
sleep 1
sudo umount -f /opt/data1/

export site=js

sudo mkfs.ext4 -N 9830400 /dev/sdf
sudo mount /dev/sdf /opt/data1
sudo rsync -az --progress /mnt/sdg/ /opt/data1/
sudo mkdir -p /opt/data1/$site-prod_cache/compiled
sudo mkdir -p /opt/data1/$site-prod_cache/caches
sudo mkdir -p /opt/data1/$site-prod_cache/ztec
sudo mkdir -p /opt/data1/$site-prod_cache/applogs
sudo chown -R www-data.www-data /opt/data1/$site-prod_cache
sudo service php-fpm start
sudo service nginx start
sudo umount /dev/sdg

sudo crontab -e 
tabedit /home/ec2-user/ct.txt
sudo /var/job/run_puppet.sh
