#!/bin/bash 
stage_name="js-prod"
web_path="/var/www/http"
stable_dir="/var/www/http/stable_version"
cache_dir="/opt/data1"
NGINX_CONF="/etc/nginx"

echo "Now began to make $(stage_name) Rollback"
if [ -e $(stable_dir) ];then 
	sudo bash -c 'echo "set \$$prjroot $(stable_dir)/;" > $(NGINX_CONF)/app-snippets/$(stage_name).root'
else 
	echo "Please check $(stage_name) whether to create a stable version !!!" ||  exit 1
fi
sudo rm -rf $(stable_dir)/var
sudo mkdir -p $(cache_dir)/$(stage_name)_cache
sudo ln -s $(cache_dir)/$(stage_name)_cache $(stable_dir)/var
sudo chown -R www-data:www-data $(stable_dir)
sudo rm -rf $(web_path)/$(stage_name)
sudo ln -s $(stable_dir) $(web_path)/$(stage_name)
sudo chown -R www-data:www-data $(web_path)/$(stage_name)
sudo service php-fpm restart
sudo service nginx reload
