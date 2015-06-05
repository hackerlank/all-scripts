export appname := proxy
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

PUPPET_ROOT := /home/ec2-user/puppet

include $(MKROOT)/common/common.mak

define fetch_rpms
if [ -e $(repo_dir) ]; then cp -r $(repo_dir)/rpms/$(1) $(2); \
else $(SSH_KEY_ENV) $(RSYNC) -e "$(repo_ssh)" $(repo_loc):$(repo_dir)/rpms/$(1) $(2); fi
endef

define init_host_name_conf
sudo bash -c 'echo "host_name=$$(cat /home/ec2-user/nodename \
		| $(SED) "s/^am-/aa-/" | $(SED) "s/^jenjen-/mje-/" | $(SED) "s/^jjs-/mjs-/" \
		| tr a-z A-Z)" > /var/job/host_name.conf'
endef

define install_proxy
xargs -n 1 -P 5 -I {} bash -c " \
	$(SSH_KEY_ENV) $(RSYNC) -e '$(stack_ssh)' ../$(tmpunpack).tar.gz $(stack_user)@\$$0:~ ; \
	$(stack_ssh) -t -t $(stack_user)@\$$0 \
	        'mkdir -p $(remotedir); rm -fr $(remotedir)/*; \
		 tar xf $(tmpunpack).tar.gz -C $(remotedir); \
		 cd $(remotedir)/stages; \
		 make $(vm_action) stack_fullname=$(stack_fullname) region=$(region) stage_name=$(stage_name) mark=$(mark); rs=\$$?; \
		 if [ \$${rs} -eq 0 ]; then \
		 	echo Remove tmp: ~/$(remotedir) ~/$(tmpunpack).tar.gz; \
        		rm -fr ~/$(remotedir) ~/$(tmpunpack).tar.gz; \
		 else \
			echo $(FAILED_MARK); \
		 fi' | $(SED) \"s/(.*)/\$$0: \1/\"" {}
endef

define get_stack_public_ips
grep -E '^INSTANCE' | tr -s '\t' | cut -f 12
endef

define authorize_group
xargs -I {} bash -c 'for port in $(1); do\
	if [ -z "$$(<$(4) grep $$0 | grep $${port})" ]; then \
		ec2-authorize --region $(2) -P TCP -p $${port} -s $$0/32 $(3); \
	fi; \
done' {}
endef

define describe_group
ec2-describe-group --region $(1) $(2) | awk '{print $$6"-"$$7" "$$10}'
endef

deploy: tmproot ?= ..
deploy: deployer_region := us-east-1
deploy: deployer_group := lestore-devops-deployer
deploy: deployer_ports := 4505-4506
deploy: tmpunpack := tmp-$(mark)-unpack
deploy: remotedir_prefix := app_unpack
deploy: remotedir := $(remotedir_prefix)_$(mark)
deploy:
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_access)
	$(call checkvar,stack_port)
	$(call checkvar,stage_name)
	$(call describe_group,$(deployer_region),$(deployer_group)) > deployer.group
	cd $(tmproot); tar czf $(tmpunpack).tar.gz *
	< $(stack_vms) $(get_stack_public_ips) > stack.ips
	if [ ! -s stack.ips ]; then echo "Error: stack.ips is empty, please check!"; exit 1; fi
	@echo '------ deploy to instances ------'
	@cat stack.ips
	@echo '-----------------------------------'
	< stack.ips $(call authorize_group,$(deployer_ports),$(deployer_region),$(deployer_group),deployer.group)
	< stack.ips $(install_proxy) | tee dispatch_rs.log
	[ -z "$$(grep '$(FAILED_MARK)' dispatch_rs.log)" ]

install: nodename := /home/ec2-user/nodename
install: minionid := /home/ec2-user/minionid
install:
	$(call checkvar,stack_fullname)
	$(call checkvar,stage_name)	
	test -f $(nodename) || echo $(region)-$(stack_fullname) > $(nodename)
	node=$$(cat $(nodename)); echo $(region)-$${node} > $(minionid)
	$(MAKE) _puppet
	$(MAKE) _run_puppet ppscript="$(PUPPET_ROOT)/manifests/02.$(stage_name).pp"
	if [ -z "$$(uname -a | grep Ubuntu)" ]; then \
	    sudo cp -fr $(MKROOT)/$(stage_name)/* /etc/squid; \
	    sudo service squid restart; \
	else \
	    sudo cp -fr $(MKROOT)/$(stage_name)/* /etc/squid3; \
	    sudo service squid3 restart; \
	fi

_puppet:
	$(call checkvar,stage_name)
	mkdir -p $(PUPPET_ROOT)
	rm -fr $(PUPPET_ROOT)/*
	cp -fr $(MKROOT)/common/puppet/* $(PUPPET_ROOT)/
	cp -fr $(MKROOT)/$(stage_name)/puppet/* $(PUPPET_ROOT)/

_run_puppet:
	$(call checkvar,ppscript)
	sudo puppet apply --verbose --color=false \
	        --modulepath $(PUPPET_ROOT)/modules:/usr/share/puppet/modules $(ppscript) | tee $(ppscript).log
	[ -n "$$(grep 'Finished catalog run in' $(ppscript).log)" ] || (echo [ERR] puppet did not Finished! ; exit 1)
	[ -z "$$(grep -E "^err\:.*" $(ppscript).log)" ] || (echo [ERR] puppet log contains 'err:'; grep -E "err\:.*" $(ppscript).log; exit 1)
