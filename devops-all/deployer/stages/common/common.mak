################ COMMON DEFINATION ################### {
SHELL=/bin/bash #-e +v +x
MAKE := make 
ifeq (Darwin,$(shell uname -s))
SED := sed -E
else
SED := sed -r
endif

NULL :=#eol
NO_OUTPUT := 1>/dev/null 2>&1
ifdef ssh_agent_pid
export SSH_KEY_ENV := export SSH_AGENT_PID=$(ssh_agent_pid); export SSH_AUTH_SOCK=$(ssh_auth_sock);
else 
export SSH_KEY_ENV := $(NULL)
endif
SSH := ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no
RSYNC := rsync -avz --progress
BBCP := bbcp 
BBCPPORT := 39000:39010
export mark ?= $(shell date +%F_%H-%M-%S)#eol
export mark_file := /home/ec2-user/latest_mark
export version := version

# these jobs only checkout on deployer and transfer to targets
export local_project := lestore_devops lestore-deployer search-z esmeralda-search
#### config files definition ####
repo_user ?= ec2-user
repo_port ?= 38022
repo_addr ?= deployer-test.opvalue.com
repo_domain ?= $(repo_addr)
repo_src ?= /home/$(repo_user)/build
repo_lock_dir := $(repo_src)/lock

repo_dir ?= /home/$(repo_user)/rsync_root
repo_loc := $(repo_user)@$(repo_addr)
repo_ssh := $(SSH) -p $(repo_port)

config_repo_user ?= $(repo_user)
config_repo_dir ?= /home/$(config_repo_user)/config_repo
config_repo_key ?= $(repo_key)
config_repo_port ?= $(repo_port)
config_repo_addr ?= $(repo_addr)
config_repo_loc := $(config_repo_user)@$(config_repo_addr)
config_repo_ssh := $(SSH) -p $(config_repo_port)
onRepo := $(shell if [ -e $(config_repo_dir) ]; then echo true; else echo false; fi)
##### config file definition ####

#### git repo definition ####
export GIT_REPO_ADDR := $(repo_addr)
export GIT_REPO_BASE := ssh://$(repo_user)@$(GIT_REPO_ADDR):$(repo_port)/~/git_repo
#### git repo definition ####

#----- check and print required variables ----- {
define checkvar
@if [ "$($(1))" == "" ]; then \
	echo "'$(1)' not defined!"; exit 1; else echo "use: '$(1)'='$($(1))'"; fi
endef
#----- check and print required variables ----- }

#--- functions to write and read params ------ {
export PARAMS := params

define write_param
    @echo $(1)=$($(1)) >> $(PARAMS)
endef

define get_param
        if [ -f $(PARAMS) ]; then <$(PARAMS) grep -E "^\s*$(1)" | cut -d '=' -f 2 | head -1; fi
endef
#--- end write and read params -------------  }

#----- functions to parse key=value0:value1:value2:... ----- {
define get_value
cut -d '=' -f 2 
endef

define get_value_of
grep '$(1)=' | $(get_value)
endef

define get_n
cut -d ':' -f $(1)
endef
#----- functions to parse key=value0:value1:value2:... ----- }

#----- functions to parse stack output ----- {
define get_stack_vms
ec2-describe-instances --region $(region) --filter 'tag:aws:cloudformation:stack-name=$(1)' --filter 'instance-state-name=$(2)'
endef

#if cannot find vms by aws:cloudformation:stack-name, use lestore:stack-name to find vms
define get_vms_by_tag
ec2-describe-instances --region $(region) --filter 'tag:$(1)' --filter 'instance-state-name=$(2)'
endef

define get_stack_vms_info
grep -E "^INSTANCE" | grep $(1) | cut -f $(2) | sort -u
endef

define get_stack_vm_ids
grep -E '^INSTANCE' | cut -f 2 | sort -u
endef

define get_stack_vm_ips
grep -E '^INSTANCE' | cut -f 4
endef

define get_stack_vms_of_app
grep -E '^TAG' | grep 'lestore:apps' | grep ",$(1)," | cut -f 3 | sort -u
endef

define get_stack_vm_ips_of_app
< $(2) $(call get_stack_vms_of_app,$(1)) | xargs -I {}  bash -c '< $(2) $(call get_stack_vms_info,$$0,4)' {}
endef

define get_stack_vm_ids_of_app
< $(2) $(call get_stack_vms_of_app,$(1)) | xargs -I {}  bash -c '< $(2) $(call get_stack_vms_info,$$0,2)' {}
endef

# stack status check
STACK_STATUS := stack-status#eol
STATUS_LIVE := live#eol
STATUS_DOWN := down#eol
STATUS_TEST := test#eol
define check_live
	if [ -n "`< $(2) grep -E '^TAG' | grep '$(STACK_STATUS)' | grep '$(STATUS_LIVE)'`" ]; then \
	        echo -----[ERR] There is live instance in $(1)-----; exit 1; fi
	@echo -----$(1) live check passed!-----
endef

define check_env
	if [ -n "`< $(1) grep -E '^TAG' | grep '$(STACK_STATUS)' | grep '$(STATUS_LIVE)'`" ]; then \
	   echo prod; \
	elif [ -n "`< $(1) grep -E '^TAG' | grep '$(STACK_STATUS)' | grep '$(STATUS_DOWN)'`" ]; then \
	   echo pre; \
	else \
	   echo test; \
	fi 
endef

# Run command and get the return value
define get_result
$(1) $(NO_OUTPUT); echo $$?
endef

NODE_PREFIX := Node#eol
STACK_OUTPUT_VMID := 1
STACK_OUTPUT_PUBDNS := 2
STACK_OUTPUT_APPS := 3

define get_ips 
grep "$(NODE_PREFIX)" | $(get_value) | $(call get_n,$(STACK_OUTPUT_PUBDNS))
endef

define get_ids 
grep "$(NODE_PREFIX)" | $(get_value) | $(call get_n,$(STACK_OUTPUT_VMID))
endef
#----- functions to parse stack output ----- }

#----- functions to find stage folder ----- {
define fallback
if [ -d $(1) ]; then echo $(1); elif [ -d default ]; then echo default; else echo NO_STAGE_DESC; fi;
endef

GIT := git
repo_name ?= origin

#----- functions to operate git ------{
# get repository address
define get_repo
$(GIT) remote -v | grep $(repo_name) | grep fetch | awk '{print $$2}'
endef

## disable ssh asking known_hosts
define disable_ask_known_hosts
   test -f $(1) || (mkdir -p $$(dirname $(1))); \
   if [ $$($(SED) '/^$$/d' $(1) | head -3 | grep -E "StrictHostKeyChecking no|CheckHostIP no|UserKnownHostsFile=/dev/null" | wc -l) -ne 3 ]; then \
	echo >> $(1); sed -i '1i StrictHostKeyChecking no\nCheckHostIP no\nUserKnownHostsFile=/dev/null' $(1); \
   fi; \
   chmod 700 $$(dirname $(1)); \
   chmod 600 $(1)
endef
## use deployer as ssh proxy for target vm
## deployer ssh agent must have key to login itself
define add_ssh_proxycommand
   test -f $(1) || (mkdir -p $$(dirname $(1))); \
   if [ $$(grep -E "$(2)|$(4)" $(1)|wc -l) -ne 2 ] || [ $$(grep -E "$(repo_domain)|$(4)" $(1)|wc -l) -ne 2 ]; then \
       $(SED) -i '/Host $(2)/,/ProxyCommand/d' $(1); \
       echo "Host $(2)" >> $(1); \
       echo "    ProxyCommand ssh -q $(3)@$(4) -p$(5) nc %h %p" >> $(1); \
       $(SED) -i '/Host $(repo_domain)/,/ProxyCommand/d' $(1); \
       echo "Host $(repo_domain)" >> $(1); \
       echo "    ProxyCommand ssh -q $(3)@$(4) -p$(5) nc %h %p" >> $(1); \
   fi; \
   chmod 700 $$(dirname $(1)); \
   chmod 600 $(1)
endef
#----- functions to operate git ------}

## composer auth
define composer_auth
sudo /usr/local/bin/composer self-update; \
composer config http-basic.$(repo_domain) lebbay passw0rd
endef
## end composer auth

################ COMMON DEFINATION ################### }

.PHONY: dispatch revision package

################ GIT PACKAGE TASKS ################### {
MASTER := master

# Run on deployer
revision: refspec := $(repo_name)/$(MASTER)
revision: repo_host ?= $(shell echo $(repo) | $(SED) 's|ssh://.*@(.*):.*$$|\1|')
revision: repo_port ?= $(shell echo $(repo) | $(SED) 's|ssh://.*@.*:([[:digit:]]{1,5})/.*$$|\1|')
revision:
	$(call checkvar,repo)
	$(call checkvar,project)
	$(call checkvar,appdir)
	$(call checkvar,src_root)
	$(call checkvar,refspec)
	mkdir -p $(src_root)
	$(call disable_ask_known_hosts,$(ssh_config))
	cd $(src_root); if [ ! -d $(project) ]; then $(GIT) clone $(repo) $(project); fi
	cd $(src_root); if [ $$($(call get_result,cd $(project); $(GIT) status)) -ne 0 ]; then rm -fr $(project); $(GIT) clone $(repo) $(project); fi
	cd $(src_root)/$(project); if [ $$($(get_repo)) != "$(repo)" ]; then ls -al | sed -r '1,3d' | awk '{print $$9}' | xargs -I {} rm -fr {}; $(GIT) clone $(repo) .;fi
	cd $(src_root)/$(project); $(GIT) reset --hard; $(GIT) checkout $(MASTER); $(GIT) branch | grep -v $(MASTER) | xargs -I {} $(GIT) branch -D {}
	cd $(src_root)/$(project); $(GIT) fetch --all; $(GIT) merge -q $(MASTER) $(repo_name)/$(MASTER)
	cd $(src_root)/$(project); $(GIT) checkout -q $(refspec)

export ssh_config := ~/.ssh/config
# It was run on target mechine to checkout project code
_source: src_root := $(repo_src)
_source: repo := $(shell $(call get_param,repo))
_source: project := $(shell $(call get_param,project))
_source: refspec := $(shell test -f $(version) && cat $(version))
_source: appdir := $(shell $(call get_param,appdir))
_source: stage_name := $(shell $(call get_param,stage_name))
_source: deployer_addr := $(shell $(call get_param,DEPLOYER_ADDR))
_source: src_dir := src
_source:
	$(call checkvar,repo)
	$(call checkvar,project)
	$(call checkvar,appdir)
	$(call checkvar,src_root)
	$(call checkvar,refspec)
	mkdir -p $(src_root)
	if [ "$(deployer_addr)" != "$$(dig $(GIT_REPO_ADDR) | grep CNAME | awk '{print $$5}' | sed 's/\.$$//')" ]; then \
            $(call add_ssh_proxycommand,$(ssh_config),$(GIT_REPO_ADDR),$(stack_user),$(deployer_addr),$(stack_port)); \
        fi
	test -x /usr/bin/git || sudo yum install git -y
	$(MAKE) revision repo=$(repo) project=$(project) src_root=$(src_root) appdir=$(appdir) refspec=$(refspec)
	$(MAKE) _pre src_root=$(src_root) project=$(project) appdir=$(appdir) stage_name=$(stage_name)
	mkdir -p $(APP_ROOT)/$(src_dir)
	rm -fr $(APP_ROOT)/$(src_dir)/*
	cd $(repo_src)/$(project)/$(appdir); cp -fr . $(APP_ROOT)/$(src_dir)/
	cd $(APP_ROOT); ls -al | $(SED) '1,3d' | awk '{print $$9}' | grep -v '$(src_dir)' | xargs -I {} cp -fr {} $(APP_ROOT)/$(src_dir)/
	cp -f $(APP_ROOT)/stages/$(version) $(APP_ROOT)/$(src_dir)/

# get project config file
config:
	$(call checkvar,appname)
	$(call checkvar,build_dir)
	$(call checkvar,tmpname)
	$(call checkvar,stage_name)
ifeq ($(onRepo),true)
	-[ -d $(config_repo_dir)/$(appname)/config/$(stage_name) ] && mkdir -p $(build_dir)/$(tmpname)/stages/$(stage_name) \
		&& cp -rf $(config_repo_dir)/$(appname)/config/$(stage_name)/* $(build_dir)/$(tmpname)/stages/$(stage_name)
	-[ -d $(config_repo_dir)/$(appname)/config/common ] && mkdir -p $(build_dir)/$(tmpname)/stages/$(stage_name) \
		&& cp -rf $(config_repo_dir)/$(appname)/config/common/* $(build_dir)/$(tmpname)/stages/$(stage_name)
else
	-mkdir -p $(build_dir)/$(tmpname)/stages/$(stage_name) \
		&& $(RSYNC) -e "$(config_repo_ssh)" $(config_repo_loc):$(config_repo_dir)/$(appname)/config/$(stage_name)/* $(build_dir)/$(tmpname)/stages/$(stage_name) 
	-mkdir -p $(build_dir)/$(tmpname)/stages/$(stage_name) \
		&& $(RSYNC) -e "$(config_repo_ssh)" $(config_repo_loc):$(config_repo_dir)/$(appname)/config/common/* $(build_dir)/$(tmpname)/stages/$(stage_name)
endif
	
################ GIT PACKAGE TASKS ################### }

################ DISPATCH TASKS ################### {
export NULL_STACK := -1
#export stage_name ?= # must def
export stage ?= $(shell $(call fallback,$(stage_name)))
export stack_user ?= ec2-user
export stack_name ?= $(stage_name)
export stack_prefix = lestore-stage-$(stack_name)
export stack_id ?= 0
export stack_fullname = $(stack_prefix)-$(stack_id)
#export stack_key ?= # must def
export stack_access ?= /home/$(stack_user)/.awstools/keys/${stack_key} 
export stack_port ?= 38022
export vm_action ?= install
FAILED_MARK := !! Dispatch Failed !!

ifeq ($(stack_access),)
stack_ssh := $(SSH) -p $(stack_port) #-i $(stack_access)
else
stack_ssh := $(SSH) -p $(stack_port) -i $(stack_access)
endif
stack_ssh_bbcp := $(stack_ssh) -xa -oFallBackToRsh=no -l %U %H $(BBCP) 

#$(SSH_KEY_ENV) $(RSYNC) -e '$(stack_ssh)' $(tmproot)/$(tmpunpack).tar.gz $(stack_user)@\$$0:~ ;
define dispatch_app
xargs -n 1 -P 6 -I {} bash -xec "( \
$(SSH_KEY_ENV) $(BBCP) -Z $(BBCPPORT) -s 4 -zvP 2 -T '$(stack_ssh_bbcp)' $(tmproot)/$(tmpunpack).tar.gz \
        $(stack_user)@\$$0:/home/$(stack_user)/$(tmpunpack).tar.gz ; \
$(stack_ssh) -A -t -t $(stack_user)@\$$0 \
        'mkdir -p $(remotedir); rm -fr $(remotedir)/*; \
        tar xf $(tmpunpack).tar.gz -C $(remotedir); \
        cd $(remotedir)/stages; \
	r=0; \
	if [ -z "$(filter $(local_project),$(project))" ]; then flock -x $(repo_lock) -c \"make _source\"; r=\$$?; cd ../$(src_dir)/stages; fi; \
        if [ \$${r} -eq 0 ]; then make $(vm_action) stack_fullname=$(stack_fullname) stage_name=$(stage_name); rs=\$$?; \
          if [ \$${rs} -eq 0 ]; then \
	    echo Remove tmp: ~/$(remotedir) ~/$(tmpunpack).tar.gz; \
            rm -fr ~/$(remotedir) ~/$(tmpunpack).tar.gz; \
       	    echo $(mark) > $(mark_file); \
	  else \
	    echo $(FAILED_MARK); \
	  fi;fi') | $(SED) \"s/(.*)/\$$0: \1/\"" {}
endef

# dispatch project to targets
dispatch: tmproot ?= ..
dispatch: tmpunpack:= tmp-$(mark)-unpack
dispatch: remotedir_prefix := app_unpack
dispatch: remotedir := $(remotedir_prefix)_$(mark)
dispatch: src_dir := src
dispatch: stack_vms ?= stack.vms
dispatch: repo_lock := /tmp/$(project).lock
dispatch:
	$(call checkvar,project)
	$(call checkvar,appname)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_access)
	$(call checkvar,stack_port)
	cd $(tmproot); tar cf $(tmpunpack).tar.gz *
	$(call get_stack_vm_ips_of_app,$(appname),$(stack_vms)) > stack.ips
	if [ -f common/target ] && [ ! -s stack.ips ]; then \
		$(call get_stack_vm_ips_of_app,$$(cat common/target),$(stack_vms)) > stack.ips; fi
	@echo '------ dispatch to instances ------'
	@cat stack.ips
	@echo '-----------------------------------'
	if [ ! -s stack.ips ]; then echo "Error: stack.ips is empty, please check!"; exit 1; fi
	touch stack.internal.ips
	while [ `< stack.internal.ips wc -l` -ne `< stack.ips wc -l` ]; do \
		dig `cat stack.ips` +noall +answer | grep -E 'IN\sA' | grep -v ';' | awk '{print $$5}' > stack.internal.ips; \
		cat stack.internal.ips; \
		done 
	cat stack.internal.ips | $(dispatch_app) | tee dispatch_rs.log
	[ -z "$$(grep '$(FAILED_MARK)' dispatch_rs.log)" ]
	for h in `cat stack.internal.ips`; do \
            vm_mark=`$(SSH_KEY_ENV) $(stack_ssh) $(stack_user)@$$h "test -f $(mark_file) && cat $(mark_file); rm -fr $(mark_file)"`; \
            if [ "$$vm_mark" != "$(mark)" ]; then echo "$$h mark check failed, try again!"; echo "$$h" >> stack.retry.ips; else echo "$$h@$$vm_mark check succeed!"; fi; \
	done
	if [ -n "$$(test -f stack.retry.ips && cat stack.retry.ips)" ]; then \
		cat stack.retry.ips | $(dispatch_app) | tee dispatch_rs.log; \
		[ -z "$$(grep '$(FAILED_MARK)' dispatch_rs.log)" ]; \
		for h in `cat stack.retry.ips`; do \
            vm_mark=`$(SSH_KEY_ENV) $(stack_ssh) $(stack_user)@$$h "test -f $(mark_file) && cat $(mark_file); rm -fr $(mark_file)"`; \
            if [ "$$vm_mark" != "$(mark)" ]; then echo "$$h mark check failed!"; exit 1; else echo "$$h@$$vm_mark check succeed!"; fi; \
		done; \
	fi
################ DISPATCH TASKS ################### }
