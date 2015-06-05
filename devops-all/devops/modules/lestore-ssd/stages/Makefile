export appname := lestore-ssd
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

export APP_CONFIGS := -e 'env_config.tmpl.php'

include $(MKROOT)/common/common.mak

AGENT_USER_HOME := /home/ec2-user
PUPPET_ROOT := $(AGENT_USER_HOME)/puppet

deploy: export appname := lestore-ssd
deploy:
	$(call checkvar,stage)
	$(call checkvar,stack_fullname)
	mkdir -p keys
	cp -f /home/ec2-user/.awstools/keys/test_rsa keys
	@echo Dispatching $(appname) at stage $(stage) [$(stack_fullname)] ...
	$(MAKE) dispatch

install:
	$(call checkvar,stage)
	$(call checkvar,stack_fullname)
	$(MAKE) _timezone
	mkdir -p /home/ec2-user/.awstools/keys/
	cp -Rf keys/* /home/ec2-user/.awstools/keys/
	sudo mkdir -p /opt/data1/{basedbdata,dbdata,db_history,table_sync}
	sudo mkdir -p /var/job
	sudo cp -Rf ../*.sh /var/job/
	sudo cp -Rf $(stage)/{ssd_db.conf,ssd.s3cfg,mail_pswd.conf} /var/job/
	[ -d /etc/ssl ] || sudo mkdir -p /etc/ssl/
	sudo cp -Rf $(stage)/ssd_cert.pem /etc/ssl/
	sudo chown root.root /etc/ssl/ssd_cert.pem
	sudo chmod 600 /etc/ssl/ssd_cert.pem
	sudo chmod a+x /var/job/*.sh
	sudo chown root /var/job/ssd.s3cfg
	sudo chmod 600 /var/job/ssd.s3cfg
	[ -f /usr/local/bin/rar ] || $(MAKE) _install_rar
	$(MAKE) _puppet

_install_rar:
	tar xzf $(MKROOT)/common/rarlinux-x64-5.1.b4.tar.gz
	cd rar; sudo $(MAKE)

_puppet:
	mkdir -p $(PUPPET_ROOT)/modules
	mkdir -p $(PUPPET_ROOT)/manifests
	-rm -fr $(PUPPET_ROOT)/manifests/04.lestore-ssd.pp
	-rm -fr $(PUPPET_ROOT)/modules/ssd
	cp -R $(APP_ROOT)/puppet/manifests/* $(PUPPET_ROOT)/manifests/
	-cp -R $(APP_ROOT)/puppet/modules/* $(PUPPET_ROOT)/modules/
	sudo chmod u+x /var/job/run_puppet.sh
	sudo bash /var/job/run_puppet.sh

_timezone:
	[ -e /etc/localtime.bak ] || sudo mv /etc/localtime /etc/localtime.bak     
	-sudo rm -f /etc/localtime
	sudo ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
	[ -e /etc/sysconfig/clock.bak ] || sudo mv /etc/sysconfig/clock /etc/sysconfig/clock.bak
	sudo bash -c 'echo ZONE=\"America/Los_Angeles\" > /etc/sysconfig/clock'
	sudo bash -c 'echo UTC=true >> /etc/sysconfig/clock'
