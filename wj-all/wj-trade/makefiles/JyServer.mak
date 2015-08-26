export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export mark ?= $(shell date +%Y%m%d_%H%M%S)
export tag ?= 06

.PHONY: show_disk backup rollback

backup: export src_path ?= /cygdrive/d
backup:
	@echo "****** Now Start to backup jyserver !!! ******"
	if [ -d $(src_path)/jyserver_$(tag) ]; then \
		echo "****** Have a jyserver_$(tag) backup !!!****** "; \
	else mv $(src_path)/jyserver $(src_path)/jyserver_$(tag); \
		echo "****** Backup jyserver_$(tag) successfully !!!****** "; \
	fi
	cd $(src_path); ls -l | grep "jyserver*"

rollback: export src_path ?= /cygdrive/d
rollback: export des_path ?= /cygdrive/d/backup/JyServer
rollback:
	@echo "****** Now Start to rollback jyserver !!! ******"
	mkdir -p $(des_path)
	mv $(src_path)/jyserver $(des_path)/jyserver_$(mark)
	mv $(src_path)/jyserver_$(tag) $(src_path)/jyserver
	echo "****** RollBack JyServer successfully !!!****** "
	cd $(src_path); ls -l | grep "jyserver*"
