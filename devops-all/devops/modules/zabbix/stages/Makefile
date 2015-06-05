export appname := monitor
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

PUPPET_ROOT := /home/ec2-user/puppet

include $(MKROOT)/common/common.mak

deploy:
	$(call checkvar,stack_fullname)
	$(call write_param,target)
	@echo Dispatching $(appname) at stage $(stage)
	$(MAKE) dispatch 

install: target := $(shell $(call get_param,target))
install:
	$(call checkvar,target)
	$(MAKE) _run_puppet ppscript="$(APP_ROOT)/stages/$(target)/puppet/manifests/09.$(target).pp"
	if [ "server" == "$(target)" ]; then \
		$(MAKE) _zabbix_mysql; \
	fi
	
_run_puppet:
	$(call checkvar,ppscript)
	sudo puppet apply --verbose --color=false \
		--modulepath $(PUPPET_ROOT)/modules:/usr/share/puppet/modules $(ppscript) | tee $(ppscript).log
	[ -n "$$(grep 'Finished catalog run in' $(ppscript).log)" ] || (echo [ERR] puppet did not Finished! ; exit 1)
	[ -z "$$(grep -E "^err\:.*" $(ppscript).log)" ] || (echo [ERR] puppet log contains 'err:'; grep -E "err\:.*" $(ppscript).log; exit 1)

_zabbix_mysql:
	@echo "create database zabbix;" | sudo mysql
	@echo "grant all on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';"| sudo mysql
	@echo "flush privileges;" | sudo mysql
	sudo mysql -uzabbix -pzabbix -hlocalhost zabbix < /usr/share/zabbix-mysql/schema.sql
	sudo mysql -uzabbix -pzabbix -hlocalhost zabbix < /usr/share/zabbix-mysql/images.sql
	sudo mysql -uzabbix -pzabbix -hlocalhost zabbix < /usr/share/zabbix-mysql/data.sql
	sudo /etc/init.d/zabbix-server restart

