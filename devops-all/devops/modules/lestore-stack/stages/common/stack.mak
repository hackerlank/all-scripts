# deployer needs:  xmlstarlet, cfn-cli, java, make
# compiler needs: rpmbuild 
# master needs: make, svn, git, rsync

#.NOTPARALLEL:

.PHONY: deploystack createstack deletestack

# ----- common vars -----
jenkins_home ?= ../../../..
#-----------------------------

# ----- vars for binding ips -----
ASSOCIATE_ADDRESS = ec2-associate-address --region $(region)
DISASSOCIATE_ADDRESS = ec2-disassociate-address --region $(region)
DESCRIBE_ADDRESS = ec2-describe-addresses --region $(region)
#-----------------------------

# ----- vars for monitor  -----
monitor_server ?= ec2-23-20-77-121.compute-1.amazonaws.com
monitor_template_dir ?= $(jenkins_home)/repo/monitor
monitor_conf ?= testenv_aws.cfg
#-----------------------------

# ----- vars for deployer -----
stack_monitor_interval ?= 15
stack_monitor_limit ?= 1500
stack_monitor_times := $(stack_monitor_limit) / $(stack_monitor_interval)

instance_monitor_interval ?= 5
instance_monitor_limit ?= 200
instance_monitor_times := $(instance_monitor_limit) / $(instance_monitor_interval)


#stack_access ?= test.aws
region ?= # must define

# ----- target on deployer -----
##### relaunch stack 
define check_stack_status 
	status="$$(cfn-list-stacks --region $(region) --stack-status CREATE_IN_PROGRESS,ROLLBACK_IN_PROGRESS,DELETE_IN_PROGRESS,UPDATE_IN_PROGRESS | grep $(stack_fullname))"; i=$$((0)) ; \
                while [ -n "$$status" ] ; do \
                        echo $$((i++)) $$status; \
                        if [ $$i -gt $$(($(stack_monitor_times))) ]; then break; fi; \
                        sleep $(stack_monitor_interval);  \
                        status="$$(cfn-list-stacks --region $(region) --stack-status CREATE_IN_PROGRESS,ROLLBACK_IN_PROGRESS,DELETE_IN_PROGRESS,UPDATE_IN_PROGRESS | grep $(stack_fullname))";  \
                done; \
	status_check="$$(cfn-list-stacks --region $(region) --stack-status $(CHECK_STACK_STATUS) | grep $(stack_fullname))"; \
	if [ $(CHECK_STACK_OP) "$$status_check" ]; then \
		echo Check status of $(stack_fullname) error:; echo $$status_check; exit 1; \
	fi; \
	exit 0; 
endef

define check_instance_status
i=0; while [ -z "$$(ec2-describe-instance-status --region $(region) $(1) -A | grep $(2))" ] && [ $$i -lt $$(($(instance_monitor_times))) ]; do \
	echo Waiting for $(1) to $(2)...; sleep $(instance_monitor_interval); i=$$(($$i+1)); done; \
	if [ $$i -eq $$(($(instance_monitor_times))) ]; then echo Check status of $(1) error.; exit 1; fi
endef

define check_all_instance_status
instances=`cat $(1)`; for instance in $${instances}; do $(call check_instance_status,$${instance},$(2)); done
endef

define change_stack
	cfn-$(stack_action)-stack $(stack_fullname) --region $(region) --template-file $(stack_tpl) \
		--capabilities CAPABILITY_IAM --parameters \
		"StackShortName=$(stack_name)-$(stack_id);Deployer=$$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)" 
endef

createstack: CHECK_STACK_STATUS = CREATE_COMPLETE
createstack: CHECK_STACK_OP = -z
createstack: stack_action = create#eol
createstack: deletestack 
	$(call checkvar,stage)
	$(call checkvar,region)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_id)
	$(call checkvar,stack_tpl)
	$(change_stack)
	$(check_stack_status)

deletestack: CHECK_STACK_STATUS = CREATE_COMPLETE,CREATE_IN_PROGRESS,ROLLBACK_IN_PROGRESS,DELETE_IN_PROGRESS
deletestack: CHECK_STACK_OP = -n
deletestack: 
	$(call checkvar,stage)
	$(call checkvar,region)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_id)
	$(MAKE) stopstack
	cfn-delete-stack $(stack_fullname) --region $(region) --force
	$(check_stack_status)

updatestack: CHECK_STACK_STATUS = UPDATE_COMPLETE
updatestack: CHECK_STACK_OP = -z
updatestack: stack_action = update#eol
updatestack:
	$(call checkvar,stage)
	$(call checkvar,region)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_id)
	$(call checkvar,stack_tpl)
	$(change_stack)
	$(check_stack_status)

stopstack: stack_vms ?= stack.vms
stopstack:
	$(call checkvar,region)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_vms)
	< $(stack_vms) $(get_stack_vm_ids) > tmp.instances
	if [ -s tmp.instances ]; then ec2-stop-instances --region $(region) $$(cat tmp.instances); $(call check_all_instance_status,tmp.instances,stopped); fi
	for elb in $(pre_elb); do \
	    if [ -s tmp.instances ] && [ -n "$$(elb-describe-lbs | awk  '{print $$2}' | grep $${elb})" ]; then \
	    	instances=$$(join tmp.instances <(elb-describe-instance-health $${elb}  | awk '{print $$2}' | sort -u)); \
	    	if [ -n "$${instances}" ]; then \
				elb-deregister-instances-from-lb $${elb} --region $(region) --instances $${instances}; \
			fi; \
		fi; \
	done;

resumestack: stack_vms ?= stack.vms
resumestack:
	$(call checkvar,region)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_vms)
ifeq ($(stack),)
	$(call get_stack_vms,$(stack_fullname),stopped) > stack.stopped.vms
endif
ifeq ($(stack),default)
	$(call get_stack_vms,$(stack_fullname),stopped) > stack.stopped.vms
endif
ifeq ($(stack),all)
	$(call get_stack_vms,$(stack_fullname),stopped) > stack.stopped.vms
	$(call get_vms_by_tag,lestore:stack-name=$(stack_fullname),stopped) >> stack.stopped.vms;
endif
ifeq ($(stack),tag)
	$(call get_vms_by_tag,lestore:stack-name=$(stack_fullname),stopped) > stack.stopped.vms;
endif
	< stack.stopped.vms $(get_stack_vm_ids) > tmp.instances
	if [ -s tmp.instances ]; then ec2-start-instances --region $(region) $$(cat tmp.instances); $(call check_all_instance_status,tmp.instances,running); fi
ifeq ($(stack),)
	$(call get_stack_vms,$(stack_fullname),running) > stack.running.vms
endif
ifeq ($(stack),default)
	$(call get_stack_vms,$(stack_fullname),running) > stack.running.vms
endif
ifeq ($(stack),all)
	$(call get_stack_vms,$(stack_fullname),running) > stack.running.vms
	$(call get_vms_by_tag,lestore:stack-name=$(stack_fullname),running) >> stack.running.vms
endif
ifeq ($(stack),tag)
	$(call get_vms_by_tag,lestore:stack-name=$(stack_fullname),running) > stack.running.vms
endif
	@echo ----- VM IPs -----
	@$(call get_stack_vm_ips_of_app,lestore-vm,stack.running.vms)
	@echo ------------------
	
binding_ip: names ?= $(MKROOT)/$(stage_name)/names
binding_ip: stack_vms ?= stack.vms
binding_ip: StackShortName = $(stack_name)-$(stack_id)
binding_ip:
	if [ -f $(MKROOT)/$(stage_name)/names ]; then \
	    < $(names) grep -v '^#' | grep '^$(StackShortName)' | tr -s ' ' | xargs -I {} bash -c ' \
		host_name=`echo {} | cut -d" " -f1`; \
		binding_ip=`echo {} | cut -d" " -f3`; \
		instance=`< $(stack_vms) grep -E "^TAG" | grep "Name" | grep "$${host_name}" | cut -f 3 | sort -u`; \
		if [ -n "$${instance}" ] && [ -n "$${binding_ip}" ]; then $(ASSOCIATE_ADDRESS) -i $${instance} $${binding_ip}; fi'; \
	else echo "no names found"; \
	fi
	
unbind_ip: stack_vms ?= stack.vms
unbind_ip:
	if [ -f $(MKROOT)/$(stage_name)/names ]; then \
	    $(call get_stack_vm_ids_of_app,frontend,$(stack_vms)) \
		    | xargs -I {} bash -c '$(DESCRIBE_ADDRESS) --filter "instance-id={}" | $(SED) "s/(.*)ADDRESS(.*)/\2/g" | cut -f2' \
		    | xargs -I {} bash -c '$(DISASSOCIATE_ADDRESS) {}'; \
	else echo "no names found"; \
	fi
