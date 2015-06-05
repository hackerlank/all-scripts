################ COMMON DEFINATION ################### {
SHELL=/bin/bash #-e +v +x
MAKE := make
SED := sed -E
NULL :=#eol
ifdef ssh_agent_pid
export SSH_KEY_ENV := export SSH_AGENT_PID=$(ssh_agent_pid); export SSH_AUTH_SOCK=$(ssh_auth_sock);
else 
export SSH_KEY_ENV := $(NULL)
endif
SSH := ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no
XML := xml
RSYNC := rsync -avz --progress
BBCP := bbcp 
BBCPPORT := 39000:39010

#svn_user ?= 
#svn_pass ?= 
ifndef svn_user
SVN := svn --non-interactive --trust-server-cert
else
SVN := svn --username $(svn_user) --password $(svn_pass) --no-auth-cache --non-interactive --trust-server-cert 
endif

SVN_DIFF := $(SVN) diff --summarize
GIT_DIFF := git diff --name-status

export mark ?= $(shell date +%F_%H-%M-%S)#eol

#----- check and print required variables ----- {
define checkvar
@if [ "$($(1))" == "" ]; then echo "'$(1)' not defined!"; exit 1; else echo "use: '$(1)'='$($(1))'"; fi
endef
#----- check and print required variables ----- }

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

define get_stack_vms_info
grep -E "^INSTANCE" | grep $(1) | cut -f $(2)
endef

define get_stack_vm_ids
grep -E '^INSTANCE' | cut -f 2
endef

define get_stack_vm_ips
grep -E '^INSTANCE' | cut -f 4
endef

define get_stack_vms_of_app
grep -E '^TAG' | grep 'lestore:apps' | grep ',$(1),' | cut -f 3
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
	        echo [ERR] There is live instance in $(1); exit 1; fi
	@echo $(1) live check passed!
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

#define get_stage
#[ ! -r $(1) ] || < $(1) $(call get_value_of,STAGE)
#endef
#
#define get_stage_fallback
#$(call fallback,$(shell $(call get_stage,$(1))))
#endef
#----- functions to find stage folder ----- }


#----- functions to generate md5 ----- {
define filter_config 
grep -v 'env_config.tmpl.php' | grep -v 'application.tmpl.properties' | grep -v 'ost-config.php'
endef

define gen_md5
xargs md5sum -b
endef
#----- functions to generate md5----- }

################ COMMON DEFINATION ################### }

.PHONY: base delta dispatch

################ PACKAGE TASKS ################### {

#----- vars for package upload ----- {
#repo_addr ?= <repo public address>
jenkins_home ?= ../../../..
repo_user ?= ec2-user
repo_dir ?= /home/$(repo_user)/rsync_root
repo_key ?=  $(jenkins_home)/repo/keys/test.aws #on jenkins master
repo_port ?= 38022
repo_loc := $(repo_user)@$(repo_addr)
repo_ssh := $(SSH) -i $(repo_key) -p $(repo_port)
#----- vars for package upload ----- }

#----- constants for repo layout ----- {
ROOT ?= ..
BUILD_DIR ?= build
BUILD_PATH ?= $(BUILD_DIR)/$(mark)
META_DIR := META-INF
META_PATH := $(BUILD_PATH)/$(META_DIR)
BASE_DIR := base
BASE_PATH := $(BUILD_PATH)/$(BASE_DIR)
DELTA_DIR := delta
DELTA_PATH := $(BUILD_PATH)/$(DELTA_DIR)
#----- constants for repo layout ----- }

#----- constants for app & metadata ----- {
BASE_PREFIX_ := 01#eol
DELTA_PREFIX_ := 03#eol
FILE_LIST_SUFFIX_ := sfl
FILE_MD5_SUFFIX_ := md5sum
REV_DIFF_SUFFIX_ := rdiff
CURRENT_REV_ := current.rev
BASE_REV_ := base.rev
SRC_FIND_FILTER_ := -type f ! -path '*/.svn/*' ! -path 'newsletter/*' ! -path '*.$(FILE_LIST_SUFFIX_)' ! -path '*/.git/*' ! -path '*/templates/ztec/*' ! -path '*/templates/caches/*' ! -path '*/.DS_Store' ! -path '$(BUILD_DIR)/*'
TAR_FILTER_ := --exclude '.svn' --exclude '.git' --exclude '.DS_Store' --exclude '/$(BUILD_DIR)/'
#----- constants for app & metadata ----- }

TMP_BASE := $(BUILD_PATH)/tmp.base

#----- repo related commands ----- {
repo_ssh_bbcp := $(repo_ssh) -xa -oFallBackToRsh=no -l %U %H $(BBCP) 
#$(RSYNC) -e "$(repo_ssh)" "$(3)"  $(repo_loc):$(repo_dir)/$(1)/$(2)/
define upload
$(SSH_KEY_ENV) $(repo_ssh) $(repo_loc) "mkdir -p $(repo_dir)/$(1)/$(2)/"; \
/usr/local/bin/$(BBCP) -Z $(BBCPPORT) -fvP 2 -T '$(repo_ssh_bbcp)' "$(3)"  $(repo_loc):$(repo_dir)/$(1)/$(2)/
endef

define log_upload
$(SSH_KEY_ENV) $(repo_ssh) $(repo_loc) \
"mkdir -p $(repo_dir)/$(1)/$(2)/; echo $(3) >> $(repo_dir)/$(1)/$(2)/history"
endef

define latest_baserev
"cd $(repo_dir)/$(appname)/$(BASE_DIR)/; \
base=\$$(ls -1 $(BASE_PREFIX_).$(appname)-base-$(1).tar.gz \
| $(SED) 's/$(BASE_PREFIX_)\.$(appname)-base-([0-9]+)\.tar\.gz/\1/' | sort -r -n | head -n 1); \
[ \"\$${base}\" != \"\" ] && echo $(2)\$${base}$(3)" 
endef

define latest_base
$(call latest_baserev,$(1),$(repo_dir)/$(appname)/$(BASE_DIR)/$(BASE_PREFIX_).$(appname)-base-,.tar.gz)
endef

define latest_rev
"cd $(repo_dir)/$(appname)/$(DELTA_DIR)/; \
rev=\$$(ls -1 $(DELTA_PREFIX_).$(appname)-delta-$(1)_$(2).tar.gz \
	| $(SED) 's/$(DELTA_PREFIX_)\.$(appname)-delta-([0-9]+)_([0-9]+)\.tar\.gz/\2/'| sort -r -n | head -n 1); \
base=\$$(ls -1 $(DELTA_PREFIX_).$(appname)-delta-$(1)_\$${rev}.tar.gz \
	| $(SED) 's/$(DELTA_PREFIX_)\.$(appname)-delta-([0-9]+)_([0-9]+)\.tar\.gz/\1/'| sort -r -n | head -n 1); \
[ \"\$${rev}\" != \"\" ] && [ \"\$${base}\" != \"\" ] && echo $(3)\$${base}_\$${rev}$(4)"
endef

define latest_delta
$(call latest_rev,$(1),$(2),$(repo_dir)/$(appname)/$(DELTA_DIR)/$(DELTA_PREFIX_).$(appname)-delta-,.tar.gz)
endef
#----- repo related commands ----- }

cleanall:
	-cd $(ROOT); rm -fr $(BUILD_DIR)/*

init:
	cd $(ROOT) ; mkdir -p $(META_PATH) ; mkdir -p $(BASE_PATH) ; mkdir -p $(DELTA_PATH)
	-cd $(ROOT) ; rm -fr $(META_PATH)/*;


_revision: revision := $$(cat "$(META_PATH)/$(CURRENT_REV_)")
_revision: init
	cd $(ROOT) ; $(SVN) info | grep "Revision: " | $(SED) 's/Revision: ([0-9]+).*/\1/' > "$(META_PATH)/$(CURRENT_REV_)"
	cd $(ROOT) ; find * $(SRC_FIND_FILTER_) > "$(META_PATH)/$(revision).$(FILE_LIST_SUFFIX_)"
	cd $(ROOT) ; < "$(META_PATH)/$(revision).$(FILE_LIST_SUFFIX_)" $(SED) 's/^(.*)$$/\"\1\"/' | $(gen_md5) > "$(META_PATH)/$(revision).$(FILE_MD5_SUFFIX_)"

_baserev:
	$(call checkvar,baserev)
	cd $(ROOT) ; echo "$(baserev)" > $(TMP_BASE)
ifeq (*,$(baserev))
ifdef repo_addr
	cd $(ROOT) ;$(SSH_KEY_ENV) $(repo_ssh) $(repo_loc) $(call latest_baserev,*) > $(TMP_BASE)
endif
endif

base: revision = $(shell cd "$(ROOT)";cat "$(META_PATH)/$(CURRENT_REV_)")
base: packagename = $(BASE_PREFIX_).$(appname)-base-$(revision)
base: _revision
	$(call checkvar,appname)
	@echo Packaging $(appname) based on revision $(revision) ...
	cd $(ROOT) ; tar -cf "$(BASE_PATH)/$(packagename).tar" -T "$(META_PATH)/$(revision).$(FILE_LIST_SUFFIX_)" $(TAR_FILTER_)
	cd $(ROOT) ; mv $(META_PATH)/$(CURRENT_REV_) $(META_PATH)/$(BASE_REV_)
	cd $(ROOT) ; cd $(BUILD_PATH) ; tar -rf "$(BASE_DIR)/$(packagename).tar" $(META_DIR)/*
	cd $(ROOT) ; cd $(BASE_PATH) ; gzip -f "$(packagename).tar" > "$(packagename).tar.gz"
	-cd $(ROOT) ; rm -fr $(META_PATH)/*;
ifdef repo_addr
	$(call checkvar,repo_addr)
	cd $(ROOT) ; cd $(BASE_PATH) ; $(call upload,$(appname),$(BASE_DIR),$(packagename).tar.gz)
	$(call log_upload,$(appname),$(BASE_DIR),$(packagename).tar.gz)
endif

define link_diff
for lnk in $(1); do \
	if [ -e $(ROOT)/$${lnk} ]; then \
		cd $(ROOT)/$${lnk}; $(SVN) diff --summarize -r $(realbase):$(revision) > tmp.diff; \
		< tmp.diff $(SED) 's|(^[A-Z].{7})(.+)|\1$${lnk}/\2|' > tmp_fixed.diff; \
		cd $(ROOT) ; cat $${lnk}/tmp_fixed.diff >> "$(META_PATH)/$(realbase)_$(revision).$(REV_DIFF_SUFFIX_)"; \
		rm $${lnk}/{tmp,tmp_fixed}.diff; \
	fi \
done;
endef

delta: revision = $(shell cd "$(ROOT)";cat "$(META_PATH)/$(CURRENT_REV_)")
delta: realbase = $(shell cd "$(ROOT)";cat "$(TMP_BASE)")
delta: packagename = $(DELTA_PREFIX_).$(appname)-delta-$(realbase)_$(revision)
delta: _revision _baserev
	$(call checkvar,appname)
	$(call checkvar,realbase)
ifneq ($(baserev),0)
	@cd $(ROOT) ; echo Packaging delta of $(appname) between revision $(realbase):$(revision) ...
	cd $(ROOT) ; $(SVN) diff --summarize -r $(realbase):$(revision) > "$(META_PATH)/$(realbase)_$(revision).$(REV_DIFF_SUFFIX_)"
ifneq ($(SVN_LINKS),)
	@echo Checking $(SVN_LINKS) ...
	$(call link_diff,$(SVN_LINKS))
endif
	cd $(ROOT) ; < "$(META_PATH)/$(realbase)_$(revision).$(REV_DIFF_SUFFIX_)" grep -E "^[AM].*" | $(SED) 's|^[AM].{7}(.+)|\1|' | $(SED) 's|\\|/|g' > "$(META_PATH)/$(realbase)_$(revision).$(FILE_LIST_SUFFIX_)"
	cd $(ROOT) ; < "$(META_PATH)/$(realbase)_$(revision).$(REV_DIFF_SUFFIX_)" grep -E "^D.*" | $(SED) 's|D.{7}(.+)|\1|' | $(SED) 's|\\|/|g' > "$(META_PATH)/$(realbase)_$(revision).rm.$(FILE_LIST_SUFFIX_)"
else
	cd $(ROOT) ; cp "$(META_PATH)/$(revision).$(FILE_LIST_SUFFIX_)" "$(META_PATH)/$(realbase)_$(revision).$(FILE_LIST_SUFFIX_)"
endif
	cd $(ROOT) ; tar -cf "$(DELTA_PATH)/$(packagename).tar" -T "$(META_PATH)/$(realbase)_$(revision).$(FILE_LIST_SUFFIX_)" $(TAR_FILTER_)
	#cd $(ROOT) ; tar -rf "$(DELTA_PATH)/$(packagename).tar" stages/common/common.mak
	cd $(ROOT) ; cd $(BUILD_PATH) ; tar -rf "$(DELTA_DIR)/$(packagename).tar" $(META_DIR)/*
	cd $(ROOT) ; cd $(DELTA_PATH) ; gzip -f "$(packagename).tar" > "$(packagename).tar.gz"
	-cd $(ROOT) ; rm -fr $(META_PATH)/*;
ifdef repo_addr
	$(call checkvar,repo_addr)
	cd $(ROOT) ; cd $(DELTA_PATH) ; $(call upload,$(appname),$(DELTA_DIR),$(packagename).tar.gz)
	$(call log_upload,$(appname),$(DELTA_DIR),$(packagename).tar.gz)
endif
	cd $(ROOT) ; rm $(TMP_BASE)
################ PACKAGE TASKS ################### }

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

stack_ssh := $(SSH) -i $(stack_access) -p $(stack_port)
stack_ssh_bbcp := $(stack_ssh) -xa -oFallBackToRsh=no -l %U %H $(BBCP) 

#$(SSH_KEY_ENV) $(RSYNC) -e '$(stack_ssh)' $(tmproot)/$(tmpunpack).tar.gz $(stack_user)@\$${dns}:~ ;
define dispatch_app
	xargs -I {} bash -c "dns={}; \
	$(SSH_KEY_ENV) $(BBCP) -Z $(BBCPPORT) -zvP 2 -T '$(stack_ssh_bbcp)' $(tmproot)/$(tmpunpack).tar.gz \
		$(stack_user)@\$${dns}:/home/$(stack_user)/$(tmpunpack).tar.gz ; \
	$(stack_ssh) -t -t $(stack_user)@\$${dns} \
	        'mkdir -p $(remotedir); rm -fr $(remotedir)/*; \
	        tar xzf $(tmpunpack).tar.gz -C $(remotedir); \
	        cd $(remotedir)/stages; \
	        make $(vm_action) stack_fullname=$(stack_fullname) stage_name=$(stage_name); rs=\$$?; \
	        [ \$${rs} -eq 0 ] && echo Remove tmp: ~/$(remotedir) ~/$(tmpunpack).tar.gz \
	        && rm -fr ~/$(remotedir) ~/$(tmpunpack).tar.gz; exit \$${rs}'"
endef

dispatch: tmproot ?= ..
dispatch: tmpunpack:= tmp-$(mark)-unpack
dispatch: remotedir_prefix := app_unpack
dispatch: remotedir := $(remotedir_prefix)_$(mark)
dispatch: stack_vms ?= stack.vms
dispatch:
	$(call checkvar,appname)
	$(call checkvar,stage_name)
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_access)
	$(call checkvar,stack_port)
	cd $(tmproot) ; tar -czf $(tmpunpack).tar.gz *
	$(call get_stack_vm_ips_of_app,$(appname),$(stack_vms)) > stack.ips
	@echo '------ dispatch to instances ------'
	@cat stack.ips
	@echo '-----------------------------------'
	cat stack.ips | $(dispatch_app)
################ DISPATCH TASKS ################### }
