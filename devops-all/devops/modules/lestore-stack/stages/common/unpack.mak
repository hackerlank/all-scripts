.PHONY: unpack fetchpack findpack

# parameters
#appname ?= lestore#eol
revision ?= *#eol
baserev ?= *#eol

# only for diff
INSTALLED_PREFIX_ := installed#eol

#----- find & fetch the source packages from repo -----

define get_base
grep -v 'delta-0_' | $(SED) 's/delta-([0-9]+)_([0-9]+)/base-\1/' \
	| $(SED) -e 's/$(DELTA_DIR)/$(BASE_DIR)/' -e 's/$(DELTA_PREFIX_)/$(BASE_PREFIX_)/' 
endef

define fetch
xargs -I {} cp {} $(to)/
endef

define fetch_remote
xargs -I {} $(RSYNC) -e "$(repo_ssh)" $(repo_loc):{} $(to)/
endef

onRepo := $(shell if [ -e $(repo_dir) ]; then echo true; else echo false; fi)

#- make findpack <appname=> [revision=] [baserev=] [repo=]
findpack: 
	$(call checkvar,appname)
	$(call checkvar,baserev)
	$(call checkvar,revision)
	$(check_appname)
ifeq (true,$(onRepo))
	bash -c $(call latest_delta,$(baserev),$(revision)) > latest_delta.tmp
else
	$(call checkvar,repo_addr)
	$(SSH_KEY_ENV) $(repo_ssh) $(repo_loc) $(call latest_delta,$(baserev),$(revision)) > latest_delta.tmp
endif
	cat latest_delta.tmp
	< latest_delta.tmp $(get_base)
	-rm latest_delta.tmp

#- make fetchpack <appname=> <to=> [revision=] [baserev=] [repo=]
fetchpack: 
	$(call checkvar,appname)
	$(call checkvar,to)
	$(call checkvar,baserev)
	$(call checkvar,revision)
	mkdir -p $(to)
	-rm -fr $(to)/*
ifeq (true,$(onRepo))
	bash -c $(call latest_delta,$(baserev),$(revision)) > $(to)/latest_delta.tmp
	cat $(to)/latest_delta.tmp | $(fetch)
	< $(to)/latest_delta.tmp $(get_base) | $(fetch)
else
	$(call checkvar,repo_addr)
	$(SSH_KEY_ENV) $(repo_ssh) $(repo_loc) $(call latest_delta,$(baserev),$(revision)) > $(to)/latest_delta.tmp
	cat $(to)/latest_delta.tmp | $(fetch_remote)
	< $(to)/latest_delta.tmp $(get_base) | $(fetch_remote)
endif
	-ls $(to)/$(DELTA_PREFIX_)*.tar.gz
	-ls $(to)/$(BASE_PREFIX_)*.tar.gz

#----- unpack the source packages

define get_rev
$$(cat $(META_DIR)/$(CURRENT_REV_))
endef

#- make unpack <from=> <to=>
unpack:
	$(call checkvar,from)
	$(call checkvar,to)
	mkdir -p $(to)
	rm -fr $(to)/*
	@#extract the base revision package 
	-ls -1 $(from)/$(BASE_PREFIX_).*.tar.gz | xargs -I {} tar -xzf {} -C $(to)
	@#extract the delta package of new revision
	-ls -1 $(from)/$(DELTA_PREFIX_).*.tar.gz | xargs -I {} tar -xzf {} -C $(to)
	@#remove the deleted files according to the revision differences
	-cat $(to)/$(META_DIR)/*.rm.$(FILE_LIST_SUFFIX_) | xargs -I {} rm -fr $(to)/{}
	@#md5 generation and verify 
	cd $(to) ; < $(META_DIR)/$(get_rev).$(FILE_MD5_SUFFIX_) $(SED) 's|[^ ]+ \*(.*)|\"\1\"|' | xargs md5sum -b > $(META_DIR)/$(INSTALLED_PREFIX_).$(get_rev).$(FILE_MD5_SUFFIX_)
	@cd $(to) ; echo Comparing $(INSTALLED_PREFIX_).$(get_rev).$(FILE_MD5_SUFFIX_) v.s. $(get_rev).$(FILE_MD5_SUFFIX_) ...
	@cd $(to) ; diff  $(META_DIR)/$(INSTALLED_PREFIX_).$(get_rev).$(FILE_MD5_SUFFIX_) $(META_DIR)/$(get_rev).$(FILE_MD5_SUFFIX_); \
	        SAME=$$?; \
	        if [ $${SAME} -ne 0 ]; then \
	                echo The packages are different from SVN!; \
	                exit $${SAME}; \
	        fi; \
	        echo ----- The packages check passed ! -----;

