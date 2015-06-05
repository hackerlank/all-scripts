export appname := memcached
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

include $(MKROOT)/common/common.mak

PUPPET_ROOT := /home/ec2-user/puppet
#export stage = $(shell $(call get_stage_fallback,stack.output))
export stage := $(shell $(call fallback,$(stage_name)))

deploy:
	@echo deploy@stage : $(stage)
	$(call checkvar,stage)
	$(MAKE) dispatch

install:
	@echo install@stage : $(stage)
	$(call checkvar,stage)
	-rm -fr $(PUPPET_ROOT)/manifests/03.memcached.pp
	cp -fR $(APP_ROOT)/puppet/manifests/*.pp $(PUPPET_ROOT)/manifests/
	sudo /var/job/run_puppet.sh
