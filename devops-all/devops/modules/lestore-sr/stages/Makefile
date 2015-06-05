export appname := lestore-sr
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

export APP_CONFIGS := -e 'env_config.tmpl.php'

include $(MKROOT)/common/common.mak

AGENT_USER_HOME := /home/ec2-user
PUPPET_ROOT := $(AGENT_USER_HOME)/puppet

deploy: export appname := lestore-sr
deploy:
	$(call checkvar,stage)
	$(call checkvar,stack_fullname)
	@echo Dispatching $(appname) at stage $(stage) [$(stack_fullname)] ...
	$(MAKE) dispatch

install:
	$(call checkvar,stage)
	$(call checkvar,stack_fullname)
	#sudo yum install -y ImageMagick
	#sudo yum install -y inotify-tools
	#sudo yum --enablerepo epel-testing install -y s3cmd
	#sudo yum install -y mysql
	#mkdir -p /home/ec2-user/.awstools/keys/
	@# add ssh key for cms upload image
	#cp -Rf keys/* /home/ec2-user/.awstools/keys/
	sudo mkdir -p /var/job
	sudo cp -Rf $(APP_ROOT)/*.sh /var/job/
	sudo mkdir -p /var/job/watermarks/gen
	sudo cp -Rf $(APP_ROOT)/watermarks/* /var/job/watermarks/
	sudo mkdir -p /var/job/materials
	sudo cp -Rf $(APP_ROOT)/materials/* /var/job/materials/
	sudo cp -f $(stage)/{img.s3cfg,sr_rsync.conf,sr_thumb.conf} /var/job/
	#sudo cp -f $(stage)/cms_upload_rsa /home/ec2-user/.awstools/keys
	sudo chmod a+x /var/job/*.sh
	sudo chown root /var/job/img.s3cfg
	sudo chmod 600 /var/job/img.s3cfg
	sudo mkdir -p /opt/data1/jjsimg
	sudo mkdir -p /opt/data1/log
	$(MAKE) _puppet
	$(MAKE) _timezone

_puppet:
	$(call checkvar,stage)
	mkdir -p $(PUPPET_ROOT)/modules
	mkdir -p $(PUPPET_ROOT)/manifests
	-rm -fr $(PUPPET_ROOT)/manifests/04.lestore-sr.pp
	-rm -fr $(PUPPET_ROOT)/modules/sr
	cp -R $(APP_ROOT)/stages/$(stage)/*.pp $(PUPPET_ROOT)/manifests/
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
