
.PHONY: show_info show_disk update_sysconf rollback_sysconf
export mark ?= $(shell date +%Y%m%d_%H%M%S)

show_info:
	free -m
show_disk:
	df -h

update_sysconf: export src_path ?= /cygdrive/d/zzinfo/tzt/jy
update_sysconf: export des_path ?= /cygdrive/d/backup/MobileStock
update_sysconf:
	@echo Now began to Update MobileStock sysconfig.ini file.
	mkdir -p $(des_path)
	if [ -e $(des_path)/SYSCONFIG.INI ];then \
		cp -f $(des_path)/SYSCONFIG.INI $(src_path)/ ; \
		sed.exe -i '/154/a\154=INQUIREFUNDGSEX' $(src_path)/SYSCONFIG.INI ; \
		sed.exe -i 's/154=INQUIREJJGSEX1/;154=INQUIREJJGSEX1/g' $(src_path)/SYSCONFIG.INI ; \
		unix2dos.exe $(src_path)/SYSCONFIG.INI ; \
		grep.exe -C 3 -n "154" $(src_path)/SYSCONFIG.INI ; \
	else cp $(src_path)/SYSCONFIG.INI $(des_path); \
		sed.exe -i '/154/a\154=INQUIREFUNDGSEX' $(src_path)/SYSCONFIG.INI; \
		sed.exe -i 's/154=INQUIREJJGSEX1/;154=INQUIREJJGSEX1/g' $(src_path)/SYSCONFIG.INI; \
		unix2dos.exe $(src_path)/SYSCONFIG.INI; \
		grep.exe -C 3 -n "154" $(src_path)/SYSCONFIG.INI; \
	fi
	
rollback_sysconf: export src_path ?= /cygdrive/d/zzinfo/tzt/jy
rollback_sysconf: export des_path ?= /cygdrive/d/backup/MobileStock
rollback_sysconf:
	@echo Now began to Rollback MobileStock sysconfig.ini file.
	mv.exe $(src_path)/SYSCONFIG.INI $(des_path)/SYSCONFIG_$(mark).INI
	cp $(des_path)/SYSCONFIG.INI $(src_path)
	grep.exe -C 2 -n "154" $(src_path)/SYSCONFIG.INI
