export appname := lestore-logman
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

export APP_CONFIGS := -e 'env_config.tmpl.php'

include $(MKROOT)/common/common.mak

AGENT_USER_HOME := /home/ec2-user
PUPPET_ROOT := $(AGENT_USER_HOME)/puppet

deploy: export appname := lestore-logman
deploy:
	$(call checkvar,stage)
	$(call checkvar,stack_fullname)
	mkdir -p keys
	cp -f /home/ec2-user/.awstools/keys/prod_rsa keys
	@echo Dispatching $(appname) at stage $(stage) [$(stack_fullname)] ...
	$(MAKE) dispatch

install:
	$(call checkvar,stage)
	$(call checkvar,stack_fullname)
	sudo mkdir -p /opt/data1/{access_log,merge_log,error_log}
	mkdir -p /home/ec2-user/.awstools/keys/
	cp -Rf keys/* /home/ec2-user/.awstools/keys/
	@#ssh-agent
	@#ssh-add /home/ec2-user/.awstools/keys/prod_rsa
	sudo mkdir -p /var/job
	sudo cp -Rf ../*.sh /var/job/
	sudo cp -f $(stage)/logman_config.sh /var/job/
	sudo chmod a+x /var/job/*.sh
	[ -f /usr/local/bin/rar ] || $(MAKE) _install_rar
	$(MAKE) _puppet
	$(MAKE) _timezone

_install_rar:
	tar xzf $(MKROOT)/common/rarlinux-x64-5.1.b4.tar.gz
	cd rar; sudo $(MAKE)

_puppet:
	mkdir -p $(PUPPET_ROOT)/modules
	mkdir -p $(PUPPET_ROOT)/manifests
	-rm -fr $(PUPPET_ROOT)/manifests/04.lestore-logman.pp
	-rm -fr $(PUPPET_ROOT)/modules/logman
	cp -R $(APP_ROOT)/puppet/manifests/* $(PUPPET_ROOT)/manifests/
	-cp -R $(APP_ROOT)/puppet/modules/* $(PUPPET_ROOT)/modules/
	sudo chmod u+x /var/job/run_puppet.sh
	sudo bash -x /var/job/run_puppet.sh
	
_timezone:
	[ -e /etc/localtime.bak ] || sudo mv /etc/localtime /etc/localtime.bak     
	-sudo rm -f /etc/localtime
	sudo ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
	[ -e /etc/sysconfig/clock.bak ] || sudo mv /etc/sysconfig/clock /etc/sysconfig/clock.bak
	sudo bash -c 'echo ZONE=\"America/Los_Angeles\" > /etc/sysconfig/clock'
	sudo bash -c 'echo UTC=true >> /etc/sysconfig/clock'
