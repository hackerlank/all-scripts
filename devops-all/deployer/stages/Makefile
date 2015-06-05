export appname := lestore-deployer
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))
export COMMON := common.mak

.PHONY: deploy install

include $(MKROOT)/common/common.mak
#include $(MKROOT)/common/unpack.mak

AGENT_USER_HOME := /home/ec2-user
PUPPET_ROOT := $(AGENT_USER_HOME)/puppet

#export stage = $(shell $(call get_stage_fallback,stack.output))
export stage := $(shell $(call fallback,$(stage_name)))

deploy:
	@echo deploy@stage : $(stage)
	$(call checkvar,stage)
	#$(MAKE) fetchpack appname=lestore-stack baserev=* revision=* to=$(APP_ROOT)/tmp
	#mv $(APP_ROOT)/tmp/* $(APP_ROOT)/
	#rm -fr $(APP_ROOT)/tmp
	##ls -t -1 $(repo_dir)/lestore-stack/delta/03.lestore-stack-delta-0_*.tar.gz | head -n 1 | xargs -I {} cp {} $(APP_ROOT)
	mkdir -p $(APP_ROOT)/keys
	cp -fr $(AGENT_USER_HOME)/.awstools/keys/* $(APP_ROOT)/keys
	$(MAKE) dispatch

install:
	@echo install@stage : $(stage)
	$(call checkvar,stage)
	-mkdir -p $(AGENT_USER_HOME)/.awstools/keys
	cp -fr $(APP_ROOT)/keys/* $(AGENT_USER_HOME)/.awstools/keys/
	rm -fr $(APP_ROOT)/.git
	$(MAKE) _scripts
	$(MAKE) _puppet
	if [ -f $(APP_ROOT)/stages/version ]; then cp -f $(APP_ROOT)/stages/version $(AGENT_USER_HOME)/deployer/; fi
	find ~/.awstools/keys/ -type f | xargs -I {} chmod 600 {}
	[ -L /usr/local/bin/composer ] || $(MAKE) _composer
	#-[ -e /usr/local/bin/xmlstarlet ] || $(MAKE) _xmlstarlet
	[ -e /usr/bin/cli53 ] || $(MAKE) _cli53
	sudo resize2fs /dev/sda1
	if [ $$(free -m | grep "Swap" | awk '{print $$2}') -eq 0 ]; then \
	   sudo dd if=/dev/zero of=/var/swap bs=1024 count=1024000; \
	   sudo mkswap /var/swap; \
	   sudo swapon /var/swap; \
	fi
	#sudo mkdir -p /var/www/http/deployer
	#sudo cp $(APP_ROOT)/$(META_DIR)/current.rev /var/www/http/deployer/version
	#sudo cp $(APP_ROOT)/index.html /var/www/http/deployer/

clean:
	@echo clean@stage : $(stage)
	$(call checkvar,stage)
	rm -fr $(AGENT_USER_HOME)/tmp/*

_scripts:
	#rm -fr $(AGENT_USER_HOME)/03.lestore-stack-delta*.tar.gz
	#cp $(APP_ROOT)/03.lestore-stack-delta*.tar.gz ~
	-[ -e /usr/local/bin/bbcp ] || (sudo cp -f $(APP_ROOT)/bbcp /usr/local/bin/; sudo chmod +x /usr/local/bin/bbcp )
	-mkdir -p $(AGENT_USER_HOME)/deployer
	-rm -fr $(AGENT_USER_HOME)/deployer/*
	#cp -rf $(APP_ROOT)/{stages,$(META_DIR)}  $(AGENT_USER_HOME)/deployer/
	cp -rf $(APP_ROOT)/stages $(AGENT_USER_HOME)/deployer/
	
_puppet:
	mkdir -p $(PUPPET_ROOT)/modules
	mkdir -p $(PUPPET_ROOT)/manifests
	-rm -fr $(PUPPET_ROOT)/manifests/05.deployer.pp
	-rm -fr $(PUPPET_ROOT)/modules/deployer
	cp -R $(APP_ROOT)/puppet/manifests/* $(PUPPET_ROOT)/manifests/
	cp -R $(APP_ROOT)/puppet/modules/* $(PUPPET_ROOT)/modules/
	sudo chmod u+x $(APP_ROOT)/run_puppet.sh
	sudo $(APP_ROOT)/run_puppet.sh | tee puppet.log
	[ -z "$$(grep -E "^err\:.*" puppet.log)" ] || (echo [ERR] puppet log contains 'err:'; grep -E "err\:.*" puppet.log; exit 1)

_gender: region ?= us-east-1
_gender:
	ec2-describe-instances --show-empty-fields --region $(region) --filter 'instance-state-name=running' > instances
	<instances grep '^TAG'| grep 'aws:cloudformation:stack-name'| grep 'lestore-stage-' | grep -v 'deployer' | awk '{print $$3}' > instances.id
	<instances.id xargs -I {} bash -c "< instances grep '^TAG'| grep '{}\sName' | awk '{print \$$3,\$$5}' | $(SED) 's/lestore-stage-//'" | sort -k 1 > instances.name
	<instances.id xargs -I {} bash -c "< instances grep '^INSTANCE'| grep '{}' | awk '{print \$$2,\$$18}'" | sort -k 1 > instances.ip
	join instances.ip instances.name | awk '{print $$2"\t\t"$$3"\t#devops"}' | sort -k 2 > managed.hosts
	<instances.name awk '{print $$2}' | $(SED) 's/\-/,/g' | paste instances.name - | awk '{print $$2"\t\t"$$3}' | sort -k 1 > managed.genders
	cp -f managed.* /home/ec2-user/.awstools/
	sudo sed -i '/#devops/d' /etc/hosts 
	sudo bash -c 'cat managed.hosts >> /etc/hosts'
	rm -f instances*

_getip: region ?= us-east-1
_getip: field ?= 17
_getip:
	@ec2-describe-instances --show-empty-fields --region $(region) --filter 'instance-state-name=running' > instances
	@<instances grep '^TAG'| grep 'aws:cloudformation:stack-name'| grep 'lestore-stage-' | grep -v 'deployer' | awk '{print $$3}' > instances.id
	@<instances.id xargs -I {} bash -c "< instances grep '^TAG'| grep '{}\sName' | awk '{print \$$3,\$$5}' | $(SED) 's/lestore-stage-//'" | sort -k 1 > instances.name
	@<instances.id xargs -I {} bash -c "< instances grep '^INSTANCE'| grep '{}' | awk '{print \$$2,\$$$(field)}'" | sort -k 1 > instances.ip
	@join instances.ip instances.name | awk '{print $$2"\t\t"$$3"\t\t"$$1}' | sort -k 2
	@rm -f instances*

_gethostip: region ?= us-east-1
_gethostip:
	@$(MAKE) --no-print-directory _getip region=$(region) > host_mapping
	@preip=$$(grep 'zz-prod-1' host_mapping|awk '{print $$1}') ;\
	wwwip=$$(grep 'zz-prod-3' host_mapping|awk '{print $$1}'); \
	ticketip=$$(grep 'osticket-prod' host_mapping|awk '{print $$1}'); \
	cmsip=$$(grep 'cms-prod' host_mapping|awk '{print $$1}'); \
	eseditorip=$$(grep 'eseditor' host_mapping|awk '{print $$1}'); \
	echo -e "$$preip p.azazie.com\n$$wwwip www.azazie.com\n$$ticketip t.azazie.com\n$$cmsip cms.azazie.com\n$$cmsip editor.azazie.com\n$$cmsip img.azazie.com\n$$cmsip up.azazie.com\n$$cmsip newsletter.azazie.com\n$$eseditorip eseditor.azazie.com"
	@rm -f host_mapping
	@rm -f instances*

_action: region ?= us-east-1
_action: op := $(shell if [ "$(op)" == "stop" ]; then echo "stop"; else echo "start"; fi)
_action: status := $(shell if [ "$(op)" == "stop" ]; then echo "stopping"; else echo "pending"; fi)
_action: 
ifeq ($(instances),)
	@echo "Instances cannot be empty."
else
	@ec2-$(op)-instances --region $(region) $(instances)
	@for instance in $(instances); do \
	   i=0; while [ -n "$$(ec2-describe-instance-status --region $(region) $${instance} -A | grep $(status))" ] \
	     && [ $$i -lt $$((200 / 5)) ]; do \
	       echo Waiting for $${instance} to $(status)...; sleep 5; i=$$(($$i+1)); \
	     done; \
	   if [ $$i -eq $$((200 / 5)) ]; then echo Check status of $${instance} error.; exit 1; fi; done
endif

_genconfig: region ?= us-east-1
_genconfig:
	@$(MAKE) --no-print-directory _getip region=$(region) field=4

#_xmlstarlet:
#	tar xzf $(APP_ROOT)/xmlstarlet-1.4.0.tar.gz
#	@#edit line 55: select-usage.c
#	cd xmlstarlet-1.4.0 ; ./configure && make && sudo make install
#	sudo ln -s /usr/local/bin/xml /usr/local/bin/xmlstarlet

_cli53:
	sudo pip-python install cli53

_composer: composer := /usr/local/bin/composer
_composer:
	sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin/
	test -f $(composer) && sudo rm -fr $(composer)
	sudo ln -s $(composer).phar $(composer)

_addkey:
	@eval $$(ssh-agent|tee ~/ssh-agent.sh); find ~/.awstools/keys -type f | xargs -I {} bash -c "file \$$0 | grep PEM | awk -F':' '{print \$$1}' | xargs -I {} ssh-add {}" {}
