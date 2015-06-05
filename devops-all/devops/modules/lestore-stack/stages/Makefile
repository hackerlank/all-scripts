export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: deploy update undeploy deployapp

export appname ?= lestore-stack

export stack_id ?= 0
export stack_name ?= $(stage_name)
export stack_fullname = lestore-stage-$(stack_name)-$(stack_id)

#whether to force deploy in live stack
force ?= false

include $(MKROOT)/common/common.mak
include $(MKROOT)/common/unpack.mak
include $(MKROOT)/common/merge.mak
include $(MKROOT)/common/stack.mak
include $(MKROOT)/common/switch.mak

deploy: export stack_params ?= NONE
deploy: export dest_file := awscf.stack.json
deploy: export appname := lestore-stack
deploy: export stack_tpl=$(stack_name)/awscf.stack.json
deploy:
	$(call checkvar,stack_name)
	$(call checkvar,stack_id)
	$(call checkvar,region)
	-[ -e $(stack_name)/main.json ] && $(MAKE) merge region=$(region)
	$(MAKE) createstack
	
update: export stack_params ?= NONE
update: export dest_file := awscf.stack.json
update: export appname := lestore-stack
update: export stack_tpl=$(stack_name)/awscf.stack.json
update:
	$(call checkvar,stack_name)
	$(call checkvar,stack_id)
	$(call checkvar,region)
	-[ -e $(stack_name)/main.json ] && $(MAKE) merge region=$(region)
	$(MAKE) updatestack 

undeploy: export appname := lestore-stack
undeploy:
	$(MAKE) deletestack

deployapp: export deployer_action ?= $(deployer_action)
deployapp:
	$(call checkvar,stage)
	$(call checkvar,stack_id)
	$(call checkvar,force)
	@echo Checking stack status
ifeq ($(force),true)
	-$(call check_live,$(stack_fullname))
else
	$(call check_live,$(stack_fullname))
endif
ifeq ($(appname),lestore-stack)
	$(MAKE) deploystack no_stack_output=true
else 
	$(MAKE) deploystack
endif

