export appname := lestore-ops
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy clean install umount clean_cache_direct clean_cache update_cdn enable_cdn disable_cdn enable_auth disable_auth update_langpack update_sitemap _update_cdn _enable_cdn _disable_cdn build_filter show_info promotion enable_maintain disable_maintain create_stable_version rollback_to_stable change_color

include $(MKROOT)/common/common.mak

NGINX_CONF := /etc/nginx
NGINX_SITES := $(NGINX_CONF)/sites-enabled
PUPPET_ROOT := /home/ec2-user/puppet

ifneq ($(stage),am-prod)
define all_sites
find /var/www/http/ -maxdepth 1 -type l | grep -v -E "\/v5"
endef
else
define all_sites
find /var/www/http/ -maxdepth 1 -type l | sed -e '1 i /var/www/http/amarmoda\n/var/www/http/hochzeitstore\n/var/www/http/besthochzeit' | grep -v -E "\/v5"
endef
endif

define all_sites_1
cd /var/www/http/ ; find . -maxdepth 1 -type l | grep -v -E "\/v5" | cut -c 3-
endef

define get_last_info
grep -v "last" | xargs -I {} ls -l {} | awk '{print $$11}' | awk -F"/" '{print $$5}'
endef

define get_php_root
xargs -I {}  bash -c "if [ -f {}/application/data/env_config.php ]; then echo {}/application; else echo {}; fi;"
endef

deploy:
	@echo deploy@stage : $(stage)
	$(call checkvar,stage)
	$(MAKE) dispatch

install:
	@echo install @$(stage)

umount:
	@echo umount @$(stage)
	$(call checkvar,stage)
	sudo mkdir -p $(PUPPET_ROOT)/manifests.bak
	sudo mv $(PUPPET_ROOT)/manifests/* $(PUPPET_ROOT)/manifests.bak/
	sudo service nginx stop
	sudo service php-fpm stop
	-[ -e /dev/sdf ] && sudo umount /opt/data1
	@Check /opt/data1 umount?
	ls -al /opt/data1


_clean_cache_direct:
	@echo clean_cache_direct @$(stage)
	sudo rm -fr /opt/data1/nginxproxycache/proxy_cache_dir/*
	$(call all_sites) | $(call get_php_root) | xargs -I {} sudo rm -fr {}/templates/ztec/*
	$(call all_sites) | $(call get_php_root) | xargs -I {} sudo rm -fr {}/templates/twig/*
	$(call all_sites) | $(call get_php_root) | xargs -I {} sudo rm -fr {}/var/twig/*
	#sudo rm -fr /opt/data1/lestore_cache/caches/*

clean_nginx_cache:
	@echo clean_nginx_cache @$(stage)
	echo "/opt/data1/nginxproxycache/proxy_cache_dir/*" | sudo tee -a /tmp/delete_cache_list

clean_template_cache:
	@echo clean_template_cache @$(stage)
	$(call all_sites) | $(call get_php_root) | xargs -I {} echo "{}/templates/ztec/*" | sudo tee -a /tmp/delete_cache_list
	$(call all_sites) | $(call get_php_root) | xargs -I {} echo "{}/templates/twig/*" | sudo tee -a /tmp/delete_cache_list
	$(call all_sites) | $(call get_php_root) | xargs -I {} echo "{}/var/twig/*" | sudo tee -a /tmp/delete_cache_list

clean_sql_cache:
	@echo clean_sql_cache @$(stage)
	$(call all_sites) | $(call get_php_root) | xargs -I {} echo "{}/templates/caches/*" | sudo tee -a /tmp/delete_cache_list

clean_cache:
	@echo clean_cache @$(stage)
	$(MAKE) clean_nginx_cache
	$(MAKE) clean_template_cache
	#$(MAKE) clean_sql_cache

_update_cdn:
	$(call checkvar,approot)
	@echo Last version is $$(cat $(approot)/version)
	sudo mv $(approot)/version $(approot)/version.last
	sudo bash -c "echo \$$(cat $(approot)/version.last)_ > $(approot)/version"
	@echo Updated version is $$(cat $(approot)/version)

update_cdn:
	@echo update_cdn @$(stage)
	$(call all_sites) | $(call get_php_root) | xargs -I {} $(MAKE) _update_cdn approot={}

update_site_cdn: approot := /var/www/http/$(stage_name)
update_site_cdn: 
	$(call checkvar,stage_name)
	$(MAKE) _update_cdn approot=$(approot)

define comment_line
< $(1) $(SED) 's,^([[:space:]]*$(2)),#\1,g' > commented.tmp ; cp -f commented.tmp $(1); rm commented.tmp
endef

define uncomment_line
< $(1) $(SED) 's,^([[:space:]]*)(//|#)*([[:space:]]*$(2)),\1\3,g'> commented.tmp ; cp -f commented.tmp $(1); rm commented.tmp
endef

_enable_cdn:
	$(call checkvar,approot)
	sudo bash -c "$(call uncomment_line,$(approot)/data/env_config.php,\\\$$rs_server)"
	sudo bash -c "$(call uncomment_line,$(approot)/data/env_config.php,\\\$$rs_cdn)"
	-grep rs_server $(approot)/data/env_config.php
	-grep rs_cdn $(approot)/data/env_config.php
	sudo chown www-data.www-data $(approot)/data/env_config.php

enable_cdn:
	@echo enable_cdn @$(stage)
	$(call all_sites) | $(call get_php_root) | xargs -I {} $(MAKE) _enable_cdn approot={}
	make update_cdn

enable_site_cdn: approot=/var/www/http/$(stage_name)
enable_site_cdn:
	$(call checkvar,stage_name)
	$(MAKE) _enable_cdn approot=$(approot)

_disable_cdn:
	$(call checkvar,approot)
	sudo bash -c "$(call comment_line,$(approot)/data/env_config.php,\\\$$rs_server)"
	sudo bash -c "$(call comment_line,$(approot)/data/env_config.php,\\\$$rs_cdn)"
	-grep rs_server $(approot)/data/env_config.php
	-grep rs_cdn $(approot)/data/env_config.php
	sudo chown www-data.www-data $(approot)/data/env_config.php

disable_cdn:
	@echo disable_cdn @$(stage)
	$(call all_sites) | $(call get_php_root) | xargs -I {} $(MAKE) _disable_cdn approot={}

enable_auth:
	@echo enable_auth @$(stage)
	for c in $(NGINX_SITES)/*; do sudo bash -c "$(call uncomment_line,$${c},auth_basic)"; done;
	for c in $(NGINX_SITES)/*; do grep auth_basic $${c}; done;
	sudo chown -R www-data.www-data $(NGINX_SITES)
	sudo service nginx reload

disable_auth:
	@echo disable_auth @$(stage)
	for c in $(NGINX_SITES)/*; do sudo bash -c "$(call comment_line,$${c},auth_basic)"; done;
	sudo chown -R www-data.www-data $(NGINX_SITES)
	sudo service nginx reload

enable_maintain:
	@echo enable_maintain @$(stage)
	for c in $(NGINX_SITES)/*; do sudo bash -c "$(call uncomment_line,$${c},include app-snippets/js.maintain)"; done;
	@echo enable_maintain OK
	sudo chown -R www-data.www-data $(NGINX_SITES)
	sudo /etc/init.d/nginx reload

disable_maintain:
	@echo disable_maintain @$(stage)
	for c in $(NGINX_SITES)/*; do sudo bash -c "$(call comment_line,$${c},include app-snippets/js.maintain)"; done;
	@echo disable_maintain OK
	sudo chown -R www-data.www-data $(NGINX_SITES)
	sudo /etc/init.d/nginx reload

os_patch:
	@echo os_patch @$(stage)
	sudo yum -y update

update_langpack:
	@echo update_langpack @$(stage)
	$(call all_sites_1) | xargs -I {} sudo $(MAKE) _lang_pack -C {}/stages stage_name={}

update_sitemap:
	@echo update_sitemap @$(stage)
	$(call all_sites_1) | xargs -I {} sudo $(MAKE) _gen_sitemap -C {}/stages stage_name={}

update_allcss: BASIC_AUTH := --basic -u lebbay:passw0rd
update_allcss:
	@echo update_allcss @$(stage_name)
	project=$$(find /var/www/http/$(stage_name) -maxdepth 1 -type l | xargs -I {}  bash -c "if [ -f {}/application/data/env_config.php ]; then echo {}/application; else echo {}; fi;" |xargs -I {} cat {}/stages/$(stage_name)/project); \
	domain=www.$${project}.com; \
	if [ -z "`grep $${domain} /etc/hosts`" ]; then echo $${domain}| xargs -I {} sudo bash -c 'echo 127.0.0.1 $$0 >> /etc/hosts' {}; fi; \
	curl $(BASIC_AUTH) "http://$${domain}/min/?g=css&$$(cat /var/www/http/$(stage_name)/version)" > generated.all.css; \
	curl $(BASIC_AUTH) "http://$${domain}/min/?g=js&$$(cat /var/www/http/$(stage_name)/version)" > generated.all.js; \
	sudo sed -i "/$${domain}/d" /etc/hosts 

run_puppet:
	@echo run_puppet @$(stage)
	[ -e /var/job/run_puppet.sh ] && sudo /var/job/run_puppet.sh | tee run_puppet.log
	[ -n "$$(grep 'Finished catalog run in' run_puppet.log)" ] || (echo [ERR] puppet did not Finished! ; exit 1)
	[ -z "$$(grep -E "^err\:.*" run_puppet.log)" ] || (echo [ERR] puppet log contains 'err:'; grep -E "err\:.*" run_puppet.log; exit 1)

reset:
	@echo reset @$(stage)
	sudo ls /var/spool/cron/ | xargs -I {} sudo rm -f /var/spool/cron/{}
	sudo rm -fr $(PUPPET_ROOT)/*
	sudo rm -fr /var/www/http/*
	sudo rm -fr $(NGINX_SITES)/*
	sudo rm -fr $(NGINX_CONF)/ssl/*
	sudo rm -fr /home/ec2-user/{app_unpack*,tmp-*.tar.gz,.awstools}
	-sudo rm -fr $$(ls /var/job/* | grep -v host_name.conf);
	-sudo kill -9 $$(ps -ef | grep ssh-agent | grep -v grep | awk '{print $$2}')

create_stable_version: export web_path ?= /var/www/http
create_stable_version: export stable_dir ?= /var/www/http/stable_version
create_stable_version:
	$(call checkvar,stage_name)
	@echo Now began to make $(stage_name) stable_version 
	if [ -e $(stable_dir) ];then sudo rm -rf $(stable_dir); fi;
	$(call all_sites) |grep $(stage_name) |$(call get_last_info) | xargs -I {} sudo cp -a $(web_path)/{} $(stable_dir)
	-sudo rm -rf $(stable_dir)/var
	sudo chown -R www-data:www-data $(stable_dir)

rollback_to_stable: export web_path ?= /var/www/http
rollback_to_stable: export stable_dir ?= /var/www/http/stable_version
rollback_to_stable: export cache_dir ?= /opt/data1
rollback_to_stable: 
	$(call checkvar,stage_name)
	@echo Now began to make $(stage_name) Rollback
	if [ -e $(stable_dir) ];then sudo bash -c 'echo "set \$$prjroot $(stable_dir)/;" > $(NGINX_CONF)/app-snippets/$(stage_name).root'; \
	else echo "Please check  $(stage_name) whether to create a stable version !!!"; exit 1; fi
	-sudo rm -rf $(stable_dir)/var
	-sudo mkdir -p $(cache_dir)/$(stage_name)_cache
	sudo ln -s $(cache_dir)/$(stage_name)_cache $(stable_dir)/var
	sudo chown -R www-data:www-data $(stable_dir)
	sudo rm -rf $(web_path)/$(stage_name)
	sudo ln -s $(stable_dir) $(web_path)/$(stage_name)
	sudo chown -R www-data:www-data $(web_path)/$(stage_name)
	sudo service php-fpm restart
	sudo service nginx reload

prod_env:
	sudo bash -c 'echo "stage=prod" > /var/job/stage'
	$(MAKE) prod_maillist
	$(MAKE) disable_cdn
	$(MAKE) disable_auth

pre_env:
	sudo bash -c 'echo "stage=pre" > /var/job/stage'
	$(MAKE) pre_maillist
	$(MAKE) disable_cdn
	$(MAKE) enable_auth

prod_env2:
	sudo bash -c 'echo "stage=prod" > /var/job/stage'
	$(MAKE) prod_stage
	$(MAKE) disable_cdn
	$(MAKE) disable_auth

pre_env2:
	sudo bash -c 'echo "stage=pre" > /var/job/stage'
	$(MAKE) pre_stage
	$(MAKE) disable_cdn
	$(MAKE) enable_auth

prod_stage:
	$(call all_sites) | $(call get_php_root) | xargs -I {} \
		sudo sed -i -E 's/(\$$stage\s*=\s*'\'')pre('\''.*)/\1production\2/g' {}/data/env_config.php
pre_stage:
	$(call all_sites) | $(call get_php_root) | xargs -I {} \
		sudo sed -i -E 's/(\$$stage\s*=\s*'\'')production('\''.*)/\1pre\2/g' {}/data/env_config.php

prod_maillist:
	$(call all_sites) | $(call get_php_root) | xargs -I {} \
		sudo sed -i -E 's/(\['\'maillist\''\])(\s*=\s*'\'')([a-z]+)(.*)/\1\2prod\4/g' {}/data/env_config.php
	$(call all_sites) | $(call get_php_root) | xargs -I {} bash -c '\
		mailist=`< {}/data/env_config.php grep "maillist" | grep "prod"`; \
		[ -n "$${mailist}" ] || echo [ERROR]prod_maillist failed.'

pre_maillist:
	$(call all_sites) | $(call get_php_root) | xargs -I {} \
		sudo sed -i -E 's/(\['\'maillist\''\])(\s*=\s*'\'')([a-z]+)(.*)/\1\2pre\4/g' {}/data/env_config.php
	$(call all_sites) | $(call get_php_root) | xargs -I {} bash -c '\
		mailist=`< {}/data/env_config.php grep "maillist" | grep "pre"`; \
		[ -n "$${mailist}" ] || echo [ERROR]pre_maillist failed.'

build_filter:
	cd /var/www/http/$(stage_name); projects="JJsHouse JenJenHouse DressFirst AmorModa JennyJoseph VBridal"; \
	for p in $${projects}; do  echo Building filter for $${p}; \
	php htm/index.php "cronjob/rebuildFilter2/project_name/$${p}"; done

show_info:
	df -h
	df -i
	free -m
	cat /var/www/http/$(stage_name)/version

promotion:
	cd /var/www/http/js-prod/stages/common; seq 12 | xargs -I {} sudo php ipadmini.php {}
	
clean:
	cd /home/ec2-user; rm -fr app_unpack*
	cd /home/ec2-user; rm -fr tmp-*.tar.gz

cand_upgrade: stage := $(stage_name)
cand_upgrade: web_path := /var/www/http
cand_upgrade: snapshot := $(stage)_snapshot.sh
cand_upgrade:
	$(call checkvar,stage)
	echo '#!/bin/bash' > $(snapshot)
	[[ -L $(web_path)/$(stage) ]] && echo current=`readlink $(web_path)/$(stage)` >> $(snapshot)
	-[[ -L $(web_path)/$(stage).last ]] && echo last=`readlink $(web_path)/$(stage).last` >> $(snapshot)
	[[ -L $(web_path)/$(stage)-c ]] && echo cand_current=`readlink $(web_path)/$(stage)-c` >> $(snapshot)
	-[[ -L $(web_path)/$(stage)-c.last ]] && echo cand_last=`readlink $(web_path)/$(stage)-c.last` >> $(snapshot)
	sudo cp -f $(snapshot) $(web_path)/$(snapshot)
	[[ -e $(web_path)/$(snapshot) ]] && sudo bash -c 'source $(web_path)/$(snapshot) && echo "set \$$prjroot $$cand_current/;" > /etc/nginx/app-snippets/$(stage).root' && sudo service nginx reload
	sudo rm -rf $(web_path)/$(stage).last && sudo mv $(web_path)/$(stage) $(web_path)/$(stage).last
	source $(web_path)/$(snapshot) && sudo ln -s $$cand_current $(web_path)/$(stage)
	sudo rm -rf $(web_path)/$(stage)-c.last && sudo mv $(web_path)/$(stage)-c $(web_path)/$(stage)-c.last
	#update cdn/auth and so on
	$(MAKE) enable_site_cdn stage_name=$(stage)
	sudo sed -i -E 's/(\$$stage\s*=\s*'\'')production('\''.*)/\1pre\2/g' $(web_path)/$(stage).last/data/env_config.php
	sudo sed -i -E 's/(\$$stage\s*=\s*'\'')pre('\''.*)/\1production\2/g' $(web_path)/$(stage)/data/env_config.php
	
am_create: domain = amarmoda hochzeitstore besthochzeit
am_create:
	for d in $(domain); do \
		sudo su - www-data -c "/usr/local/bin/php /var/www/http/$${d}/sitemap/create_robots.php $${d}"; \
		sudo su - www-data -c "/var/www/http/$${d}/stages/common/gen_sitemap.sh $${d} $${d}"; \
	done

am_sync: domain = amarmoda hochzeitstore besthochzeit
am_sync: RSYNC_FILTER := --exclude "robots*.txt" --exclude "sitemap/files/*" --exclude "sitemap*.xml" --exclude "templates"
am_sync: 
	@echo "sync am code"
	for d in $(domain); do \
		sudo rsync -az $(RSYNC_FILTER) /var/www/http/$(stage_name).current/ /var/www/http/$${d}; \
	done

am_cdn: approot := /var/www/http
am_cdn:
	sudo rm -fr $(approot)/am-prod/themes/fitdress
	cd $(approot)/am-prod/themes; sudo ln -s $(approot)/fd-prod/themes/fitdress fitdress
	sudo rm -fr $(approot)/am-prod/themes/lilysdress
	cd $(approot)/am-prod/themes; sudo ln -s $(approot)/ld-prod/themes/lilysdress lilysdress

install_git:
	sudo yum install git -y

zz_block_cn_switch_on:
	sudo sh -c "echo 'set \$$block_cn_switch on;' > $(NGINX_CONF)/app-snippets/block_cn_switch"
	sudo service nginx reload

zz_block_cn_switch_off:
	sudo sh -c "echo 'set \$$block_cn_switch off;' > $(NGINX_CONF)/app-snippets/block_cn_switch"
	sudo service nginx reload
change_color:
	sudo sed -i 's/DIR\ 01;34/DIR\ 38;5;27/g' /etc/DIR_COLORS
	sudo sed -i 's/EXEC\ 01;32/EXEC\ 38;5;34/g' /etc/DIR_COLORS
	sudo sed -i '$$a colorscheme desert' /etc/vimrc
