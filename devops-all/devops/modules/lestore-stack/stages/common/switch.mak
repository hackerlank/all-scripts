TMPINST := instances.tmp

R53_CLI = $$(cat ~/.awstools/keys/dns-binder.credentials); cli53
R53_LIST = $(R53_CLI) list
R53_CREATE = $(R53_CLI) create
R53_DELETE = $(R53_CLI) delete
R53_RRCREATE = $(R53_CLI) rrcreate --replace
R53_RRDELETE = $(R53_CLI) rrdelete

elb_monitor_interval ?= 10
elb_monitor_limit ?= 900
elb_monitor_times := $(elb_monitor_limit) / $(elb_monitor_interval)

define get_vm_ids_of_status
< $(1) grep '^TAG' | grep '$(STACK_STATUS)' | grep '$(2)' | cut -d $$'\t' -f 3 | sort -u
endef

define get_public_ips_of_instances
< $(1) xargs -I {} bash -c '< $(2) $(call get_stack_vms_info,$$0,4)' {} | $(SED) "s/ec2-([0-9]+)-([0-9]+)-([0-9]+)-([0-9]+).(.*)/\1.\2.\3.\4/"
endef

define add_tag
xargs -I {} ec2-create-tags {} --tag $(1)=$(2) --region $(region)
endef

define attach
	@echo Attach $$(cat $(1)) to $(2)
	if [ -n '$(3)' ]; then < $(1) $(call add_tag,$(STACK_STATUS),$(3)); fi
	for elb in $(2); do \
		echo Attaching $${elb} ...; \
		instances=$$(cat $(1)); elb-register-instances-with-lb $${elb} --region $(region) --instances $${instances}; \
	done;
endef

define detach 
	@echo Detach $$(cat $(1)) from $(2)
	for elb in $(2); do \
		echo Detaching $${elb} ...; \
		instances=$$(cat $(1)); elb-deregister-instances-from-lb $${elb} --region $(region) --instances $${instances}; \
	done;
	if [ -n '$(3)' ]; then < $(1) $(call add_tag,$(STACK_STATUS),$(3)); fi
endef

define check_elb_status
	@echo Check status of $$(cat $(1)) in $(2)
	for elb in $(2); do instances=$$(cat $(1)); i=0; \
		while [ $$(cat $(1) | wc -l) -ne $$(elb-describe-instance-health $${elb} --region $(region) --instances $${instances} | grep '$(3)' | wc -l) ] \
			&& [ $$i -lt $$(($(elb_monitor_times))) ]; do \
			echo Waiting for $${instances} all to be $(3)...; sleep $(elb_monitor_interval); i=$$(($$i+1)); \
		done; \
		if [ $$i -eq $$(($(elb_monitor_times))) ]; then echo [ERROR]Some instances in $${elb} is not finished.; exit 1; fi; \
	done;
endef

define get_instance_az
< $(1) xargs -I {} grep -E "^INSTANCE" | grep '{}'| cut -f12 $(2)
endef

define enable_elb_az
for elb in $(1); do elb-enable-zones-for-lb $${elb} --region $(region) --availability-zones $(2); done
endef

define verify_detach
rm -rf instances; for elb in $(1); do \
		elb-describe-instance-health $${elb} --region $(region) | tr -s ' ' | cut -d ' ' -f2 >> instances; done; \
		< instances $(SED) '/^$$/d' | sort | uniq > exist_instances; \
		cp exist_instances $(2); \
		< $(3) xargs -I {} $(SED) -i '/{}/d' exist_instances; \
		[ -s exist_instances ] || (echo "[ERR] No production instance is not allowed."; exit 1)
endef

define check_stack_no
if [ $$(<$(1) grep -E 'aws:cloudformation:stack-name|lestore:stack-name' | grep $(2) | awk '{print $$5}' | sort -u | wc -l) -ne 2 ]; then \
	echo -----[ERR]: The stack number not equal to 2 before swith! -----; \
	exit 1; \
else \
	echo ----- Stack number check passed. -----; \
fi
endef

define check_auth
for vm_id in $$(cat $(2)); do \
    vm_ip=$$(< $(1) grep -E "^INSTANCE" | grep $$vm_id | cut -f 4 ); \
    http_code=$$(curl -I -m 15 -o /dev/null -s -w %{http_code} $${vm_ip}/stack ); \
    if [ $${http_code} -ne 200 ]; then \
        echo "$${vm_ip} authority is on, please check!"; \
        exit 1; \
    else \
    	echo "$${vm_ip} ok" ; \
    fi; \
done
endef


switch: prod_elb = $(shell < $(MKROOT)/$(stage_name)/elb $(call get_value_of,prod))
switch: pre_elb = $(shell < $(MKROOT)/$(stage_name)/elb $(call get_value_of,pre))
switch:
	$(call checkvar,region)
	$(call checkvar,stage_name)
	$(call checkvar,prod_elb)
	$(call checkvar,pre_elb)
ifeq ($(stack),)
	$(call get_stack_vms,$(stack_prefix)-*,running) $  > allstack.vms
endif
ifeq ($(stack),default)
	$(call get_stack_vms,$(stack_prefix)-*,running) > allstack.vms
endif
ifeq ($(stack),all)
	$(call get_stack_vms,$(stack_prefix)-*,running) > allstack.vms
	$(call get_vms_by_tag,lestore:stack-name=$(stack_prefix)-*,running) >> allstack.vms
endif
ifeq ($(stack),tag)
	$(call get_vms_by_tag,lestore:stack-name=$(stack_prefix)-*,running) > allstack.vms
endif
ifeq ($(force),true)
	-$(call check_stack_no,allstack.vms,$(stack_prefix))
else
	$(call check_stack_no,allstack.vms,$(stack_prefix))
endif
	$(call get_vm_ids_of_status,allstack.vms,$(STATUS_LIVE)) > live_$(TMPINST)
	$(call get_vm_ids_of_status,allstack.vms,$(STATUS_DOWN)) > down_$(TMPINST)
	$(call check_auth,allstack.vms,down_$(TMPINST))
	$(call get_instance_az,live_$(TMPINST),allstack.vms) > live_azs
	< live_azs $(SED) '/^$$/d' | sort | uniq | xargs -I {} bash -c '$(call enable_elb_az,$(pre_elb),{})'
	$(call get_instance_az,down_$(TMPINST),allstack.vms) > down_azs
	< down_azs $(SED) '/^$$/d' | sort | uniq | xargs -I {} bash -c '$(call enable_elb_az,$(prod_elb),{})'
	@echo ----- Switch [prod]`cat live_$(TMPINST)` and [pre]`cat down_$(TMPINST)`-----
	$(call detach,down_$(TMPINST),$(pre_elb),)
	$(call attach,down_$(TMPINST),$(prod_elb),$(STATUS_LIVE)) 
	$(call check_elb_status,down_$(TMPINST),$(pre_elb),OutOfService)
	$(call check_elb_status,down_$(TMPINST),$(prod_elb),InService)
	$(call detach,live_$(TMPINST),$(prod_elb),$(STATUS_DOWN))
	$(call attach,live_$(TMPINST),$(pre_elb),)
	$(call check_elb_status,live_$(TMPINST),$(prod_elb),OutOfService)
	$(call check_elb_status,live_$(TMPINST),$(pre_elb),InService)
	if [ -f $(MKROOT)/$(stage_name)/names ]; then $(MAKE) binding_domain stack_vms=allstack.vms instances=down_$(TMPINST); fi

prod_elb = $(shell < $(MKROOT)/$(stage_name)/elb $(call get_value_of,prod))
pre_elb = $(shell < $(MKROOT)/$(stage_name)/elb $(call get_value_of,pre))

prod: stack_vms ?= stack.vms
prod: dns_name = $(shell curl http://169.254.169.254/latest/meta-data/public-hostname)
prod:
	$(call checkvar,region)
	$(call checkvar,stage_name)
	$(call checkvar,stack_id)
	$(call checkvar,stack_fullname)
	$(call checkvar,prod_elb)
	$(call checkvar,pre_elb)
	@echo ----- make [pre] $(stack_fullname) to [prod]-----
	$(call get_stack_vm_ips_of_app,frontend,$(stack_vms)) > stack.ips
	@echo ----- VM IPs -----
	@cat stack.ips
	@echo ------------------
	@echo check host authority status...
	@for ip in $$(cat stack.ips); do \
		http_status=$$(curl -I -m 15 -o /dev/null -s -w %{http_code} $$ip/stack ); \
		if [ $$http_status -ne 200 ]; then \
			echo "$$ip authority is on, please check!"; \
			exit 1; \
		else \
    			echo "$$ip ok" ; \
		fi; \
	done
	
	$(call get_stack_vm_ids_of_app,frontend,$(stack_vms)) > instances
	$(call get_instance_az,instances,$(stack_vms)) > azs
	< azs $(SED) '/^$$/d' | sort | uniq | xargs -I {} bash -c '$(call enable_elb_az,$(prod_elb),{})'
	$(call detach,instances,$(pre_elb),)
	$(call attach,instances,$(prod_elb),$(STATUS_LIVE))
	$(call check_elb_status,instances,$(pre_elb),OutOfService)
	$(call check_elb_status,instances,$(prod_elb),InService)
	if [ -f $(MKROOT)/$(stage_name)/names ]; then $(MAKE) binding_domain instances=instances; fi

pre: stack_vms ?= stack.vms
pre: dns_name = $(shell curl http://169.254.169.254/latest/meta-data/public-hostname)
pre:
	$(call checkvar,region)
	$(call checkvar,stage_name)
	$(call checkvar,stack_id)
	$(call checkvar,stack_fullname)
	$(call checkvar,prod_elb)
	$(call checkvar,pre_elb)
	@echo ----- make [prod] $(stack_fullname) to [pre]-----
	$(call get_stack_vm_ips_of_app,frontend,$(stack_vms)) > stack.ips
	@echo ----- VM IPs -----
	@cat stack.ips
	@echo ------------------
	$(call get_stack_vm_ids_of_app,frontend,$(stack_vms)) > detach_instances
	$(call verify_detach,$(prod_elb),prod_instances,detach_instances)
	$(call get_instance_az,detach_instances,$(stack_vms)) > azs
	< azs $(SED) '/^$$/d' | sort | uniq | xargs -I {} bash -c '$(call enable_elb_az,$(pre_elb),{})'
	$(MAKE) pre_sub exist_prod="$$(cat detach_instances | xargs -I {} grep {} prod_instances | tr '\n' ' ')"
	$(call check_elb_status,detach_instances,$(prod_elb),OutOfService)
	$(call check_elb_status,detach_instances,$(pre_elb),InService)
	for elb in $(pre_elb); do \
		if [ -n "`elb-describe-instance-health $${elb} --region $(region) | grep 'No instances'`" ]; then \
			echo [ERROR]No instance in $${elb}.; exit 1; \
		fi; \
	done;

pre_sub:
ifneq (,$(strip $(exist_prod)))
	if [ -f $(MKROOT)/$(stage_name)/names ]; then $(MAKE) unbind_domain instances=detach_instances; fi
	$(call detach,detach_instances,$(prod_elb),$(STATUS_DOWN))
endif
	$(call attach,detach_instances,$(pre_elb),$(STATUS_DOWN))
	sleep 5


binding_domain: names ?= $(MKROOT)/$(stage_name)/names
binding_domain: stack_vms ?= stack.vms
binding_domain: instances ?= instances
binding_domain: 
	$(call get_public_ips_of_instances,$(instances),$(stack_vms)) | xargs -I {} bash -c ' \
		rr=`< $(names) grep -v "^#" | grep {} | tr -s " " | cut -d" " -f2`; \
		$(R53_RRCREATE) opvalue.com $${rr} A {}'
		
unbind_domain: names ?= $(MKROOT)/$(stage_name)/names
unbind_domain: stack_vms ?= stack.vms
unbind_domain: instances ?= instances
unbind_domain: 
	$(call get_public_ips_of_instances,$(instances),$(stack_vms)) | xargs -I {} bash -c ' \
		rr=`< $(names) grep -v "^#" | grep {} | tr -s " " | cut -d" " -f2`; \
		$(R53_RRDELETE) opvalue.com $${rr}.opvalue.com. A'
