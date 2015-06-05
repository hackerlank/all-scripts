export appname := lestore-compiler
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install upload upload_rpms

include $(MKROOT)/common/common.mak

PUPPET_ROOT := /home/ec2-user/puppet

#export stage = $(shell $(call get_stage_fallback,stack.output))
export stage := $(shell $(call fallback,$(stage_name)))

stack2repo_ssh ?= $(SSH) -i `ls ~/test.aws` -p $(repo_port)

define dispatch_file
< stack.output grep ",$(appname)," | $(get_ips) | xargs -I {} bash -c "dns={}; \
$(SSH_KEY_ENV) $(RSYNC) -e \"$(stack_ssh)\" $(1) $(stack_user)@\$${dns}:~ "
endef

define upload_rpms
$(SSH_KEY_ENV) $(RSYNC) -e "$(1)" $(3) $(repo_user)@$(2):$(repo_dir)/rpms
endef

define fetch_file
< stack.output grep ",$(appname)," | $(get_ips) | xargs -I {} bash -c "dns={}; \
$(SSH_KEY_ENV) $(RSYNC) -e \"$(stack_ssh)\" $(stack_user)@\$${dns}:$(1) . "
endef

deploy:
	@echo deploy@stage : $(stage)
	$(call checkvar,stage)
	echo $(repo_addr) > info; $(call dispatch_file,info); rm -fr info
	$(call dispatch_file,$(repo_key))
	$(MAKE) dispatch
	
upload:
	$(call checkvar,repo_addr)
	$(call checkvar,repo_user)
	$(call checkvar,repo_ssh)
	$(call checkvar,repo_dir)
	$(call fetch_file,~/rpmbuild/SRPMS/*.rpm)
	$(call fetch_file,~/rpmbuild/RPMS/x86_64/*.rpm);
	$(call upload_rpms,$(repo_ssh),$(repo_addr),./*.rpm);
	rm -fr ./*.rpm

install:
	cd $(APP_ROOT)/scripts; chmod u+x compile.sh ; ./compile.sh
	make upload
	
upload_rpms:
	repo_addr=`cat ~/info`; \
	$(stack2repo_ssh) $(repo_user)@$${repo_addr} \
		"mkdir -p $(repo_dir)/rpms; rm -fr $(repo_dir)/rpms/*"; \
	$(call upload_rpms,$(stack2repo_ssh),$${repo_addr},~/rpmbuild/SRPMS/*.rpm); \
	$(call upload_rpms,$(stack2repo_ssh),$${repo_addr},~/rpmbuild/RPMS/x86_64/*.rpm);
	rm -fr ~/info ~/test.aws