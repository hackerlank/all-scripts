export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export mark ?= $(shell date +%Y%m%d_%H%M%S)

.PHONY: kill_dog kill_JyServer kill_ProgramMan kill_hqServer kill_DataAcquisitionService kill_MobileStock kill_RefreshLonNow kill_TZTDataTransmit kill_TdxCon kill_CapitalFlowsRecv kill_CapitalFlowsData kill_TransInfo kill_gjyjbBlkReal kill_hqnode kill_L2TOL1-SH kill_L2TOL1-SZ kill_DemonMrs kill_all telnet_T2_addr

kill_dog:
	taskkill /f /im udplstn.exe &
kill_JyServer:
	taskkill /f /t /im JYServer.exe &
kill_ProgramMan:
	echo "Kill ProgramMan!!!"
	cd $(MKROOT); run.exe ../taskkill-program.bat &
kill_hqServer:
	taskkill /f /t /im hqServer.exe &
kill_DataAcquisitionService:
	taskkill /f /t /im DataAcquisitionService.exe &
kill_MobileStock:
	taskkill /f /t /im MobileStock.exe &
kill_RefreshLonNow:
	taskkill /f /t /im RefreshLonNow.exe &
kill_TZTDataTransmit:
	taskkill /f /t /im TZTDataTransmit.exe &
kill_TdxCon:
	taskkill /f /t /im TdxCon.exe &
kill_CapitalFlowsRecv:
	taskkill /f /t /im CapitalFlowsRecv.exe &
kill_CapitalFlowsData:
	taskkill /f /t /im CapitalFlowsData.exe &
kill_TransInfo:
	taskkill /f /t /im TransInfo.exe &
kill_gjyjbBlkReal:
	taskkill /f /t /im gjyjbBlkReal.exe &
kill_hqnode:
	taskkill /f /t /im hqnode.exe &
kill_L2TOL1-SH:
	taskkill /f /t /im L2TOL1-SH.exe &
kill_L2TOL1-SZ:
	taskkill /f /t /im L2TOL1-SZ.exe &
kill_DemonMrs:
	taskkill /f /t /im DemonMrs.exe &
kill_all:
	echo "Kill some programs!!!"
	cd $(MKROOT); run.exe ../taskkill-all.bat &
telnet_T2_addr:
	echo "******* Telnet T2 IP:Port! ******"
	cd $(MKROOT); python.exe ../Python/telnet_T2_addr.py
