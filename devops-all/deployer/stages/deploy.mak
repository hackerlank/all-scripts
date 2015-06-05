# Usage:
# make -f deploy.mak -C /home/ec2-user/deployer/stages deployapp  
#	repo=${repo}   //define git repo url
# 	appname=${appname}  //define appname
#	project=${project_name} // define the git project, sometimes a project may contain servial apps such as lestore_devops
#	appdir=${appdir} // define the app relative path according to the project root directory
#	refspec=${refspec} // define the git version
#	master=${master} // only for applyhotfix, define master commit
# 	stage_name=${stage_name} //define the specialization of the app
# 	stack_name=${stage_name} stack_id=0 //define the target vm stack
#	stack=${stack} // self-defined stack
#	stack_params="NONE" //only for lestore-stack: template construction
# 	stack_key=${stack_key} stack_port=38022 //access info of target vm
# 	deployer_action=deploy vm_action=install //action in deployer and target vm
# 	force=false //whether to force deployment in live instances
#

export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export MKFILE=deploy.mak

#.NOTPARALLEL:
.PHONY: deploystack deployapp

include $(MKROOT)/common/common.mak

export BUILD_ROOT := /home/ec2-user/tmp/build-$(mark)
export SRC_ROOT := /home/ec2-user/build
export DEPLOYER_ROOT := /home/ec2-user/deployer
export DEPLOYER_ADDR := $(shell curl -s http://169.254.169.254/latest/meta-data/public-hostname)

##### deploy applications to the stack according to stack description and stage
export deployer_action ?= deploy
#whether to force deploy in live stack
export force ?= false

deploystack: export refspec ?= origin/master
deploystack: export master ?= origin/master
deploystack: export region ?= us-east-1
deploystack: export appname ?= $(project)
deploystack: export tmpname ?= tmp-$(mark)
deploystack: export repo ?= $(GIT_REPO_BASE)/$(project).git
deploystack: export appdir ?= .
deploystack: repo_lock := $(repo_lock_dir)/$(project)
deploystack:
	$(call checkvar,repo)
	$(call checkvar,project)
	$(call checkvar,appname)
	$(call checkvar,appdir)
	$(call checkvar,refspec)
	$(call checkvar,stack_name)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_access)
	$(call checkvar,region)
	$(call checkvar,deployer_action)
	$(call checkvar,force)
ifneq ($(stack_id),$(NULL_STACK))
ifeq ($(stack),)
	$(call get_stack_vms,$(stack_fullname),running) > stack.vms
endif
ifeq ($(stack),default)
	$(call get_stack_vms,$(stack_fullname),running) > stack.vms
endif
ifeq ($(stack),all)
	$(call get_stack_vms,$(stack_fullname),running) > stack.vms
	$(call get_vms_by_tag,lestore:stack-name=$(stack_fullname),running) >> stack.vms;
endif
ifeq ($(stack),tag)
	$(call get_vms_by_tag,lestore:stack-name=$(stack_fullname),running) > stack.vms;
endif

ifeq ($(force),true)
	-$(call check_live,$(stack_fullname),stack.vms)
else
	$(call check_live,$(stack_fullname),stack.vms)
endif
endif
	rm -fr $(PARAMS)
	$(call write_param,repo)
	$(call write_param,project)
	$(call write_param,appdir)
	$(call write_param,refspec)
	$(call write_param,stage_name)
	$(call write_param,SRC_ROOT)
	$(call write_param,DEPLOYER_ADDR)
ifeq ($(vm_action),applyhotfix)
	$(call write_param,master)
endif
	mkdir -p $(BUILD_ROOT)/$(tmpname)
	flock -x $(repo_lock) -c '$(MAKE) -f $(MKFILE) revision repo=$(repo) project=$(project) src_root=$(SRC_ROOT) appdir=$(appdir) refspec=$(refspec); r=$$?; \
	if [ $$r -ne 0 ]; then exit 1; fi; \
	if [ -n "$(filter $(local_project),$(project))" ]; then \
	    cd $(SRC_ROOT)/$(project)/$(appdir); cp -fr . $(BUILD_ROOT)/$(tmpname)/; \
	else \
	    mkdir -p $(BUILD_ROOT)/$(tmpname)/stages; \
	    rm -fr $(BUILD_ROOT)/$(tmpname)/stages/*; \
	    cp -fr $(SRC_ROOT)/$(project)/$(appdir)/stages/. $(BUILD_ROOT)/$(tmpname)/stages/; \
	fi; \
	cd $(SRC_ROOT)/$(project)/$(appdir); $(GIT) rev-parse --short HEAD > $(BUILD_ROOT)/$(tmpname)/stages/$(version); \
    	echo "****************************************************************************************"; \
    	echo "The current release version number is :" `cat $(BUILD_ROOT)/$(tmpname)/stages/$(version)`; \
    	echo "****************************************************************************************" '
	mkdir -p $(BUILD_ROOT)/$(tmpname)/stages/common
	if [ "$(appname)" != "lestore-deployer" ]; then cp -f common/common.mak $(BUILD_ROOT)/$(tmpname)/stages/common/ ; fi
	cp -f $(PARAMS) $(BUILD_ROOT)/$(tmpname)/stages/
ifeq ($(appname),search-z)
	$(call get_stack_vms,*,running) > stack_all.vms
	cp -f $(MKROOT)/stack_all.vms $(BUILD_ROOT)/$(tmpunpack)/stages/
endif
	if [ -f stack.vms ]; then cp -f stack.vms $(BUILD_ROOT)/$(tmpname)/stages/; fi
	$(MAKE) -f $(MKFILE) config build_dir=$(BUILD_ROOT) appname=$(appname) tmpname=$(tmpname) stage_name=$(stage_name)
	$(MAKE) -C $(BUILD_ROOT)/$(tmpname)/stages $(deployer_action) project=$(project) stack_access=$(stack_access) \
            stack_fullname=$(stack_fullname) stage_name=$(stage_name) stack_vms=stack.vms region=$(region)
	rm -fr $(BUILD_ROOT)/$(tmpname) 

deployapp:
	mkdir -p $(repo_lock_dir)
	mkdir -p $(BUILD_ROOT)
	rm -fr $(BUILD_ROOT)/*
	cp -fr $(DEPLOYER_ROOT)/* $(BUILD_ROOT)/
	$(MAKE) -f $(MKFILE) -C $(BUILD_ROOT)/stages deploystack
	rm -fr $(BUILD_ROOT)
