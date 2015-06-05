export appname := lestore-monitor
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

include $(MKROOT)/common/common.mak

#export stage = $(shell $(call get_stage,stack.output))
export stage := $(shell $(call fallback,$(stage_name)))

deploy:
	@echo deploy@stage : $(stage)
	$(call checkvar,stage)

#install: export stage = $(shell $(call get_stage,stack.output))
install:
	@echo install@stage : $(stage)
	@echo Do Nothing...

##### update monitor service with lastest stacks
define update_monitor
	xargs -I @@@ bash -c "vm=@@@ ; stack=\$$( echo \$$vm | cut -d ':' -f 1 ); name=\$$( echo \$$vm | cut -d ':' -f 2 ); dns=\$$( echo \$$vm | cut -d ':' -f 3 ); \
	  cat $(monitor_template_dir)/\$${name}.icinga.template.cfg | $(SED) \"s,__HOSTNAME__,\$${stack}_\$${name},g\" | sed -r \"s,__HOSTADDR__,\$${dns},g\" >> $(monitor_conf) "
endef

updatemonitor: stack_fullname = {}#eol 
updatemonitor:
	cfn-list-stacks --region $(region) --stack-status CREATE_COMPLETE | $(SED) 's,STACK[ ]+[^ ]+[ ]+([^ ]+)[ ]+.*,\1,' > stacks
	cat $(monitor_template_dir)/generic.aws.cfg > $(monitor_conf)
	cat stacks | xargs -I {} $(retrieve_stack_output) | $(filter_units) | $(update_monitor)
	cat $(monitor_conf)
	@#chmod 600 $(stack_access)
	$(SSH_KEY_ENV) rsync -avz -e "$(SSH) -i $(stack_access)" $(monitor_conf) ubuntu@$(monitor_server):~ 
	$(SSH_KEY_ENV) $(SSH) -t -t -i $(stack_access) ubuntu@\$(monitor_server) "sudo mv -f $(monitor_conf) /etc/icinga/objects/ ; sudo service icinga reload; "

