#!/bin/bash
# install glacier-cmd
# https://github.com/uskudnik/amazon-glacier-cmd-interface

if [[ -z $1 ]]
then
   	 days=`date +%Y%m%d --date='1 days ago'`
else
   	 days=$@
fi

newlog='/opt/data1/merge_log'
uploadlog="/opt/data1/merge_log/upload.log"
projects=("${backup_projects}")
cert_file="/tmp/logman_cert.pem"
glacier_vault="test"

cat <<EOF >${cert_file}
-----BEGIN CERTIFICATE-----
MIIDBjCCAe4CCQD3JkK2dZsVxjANBgkqhkiG9w0BAQUFADBFMQswCQYDVQQGEwJB
VTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0
cyBQdHkgTHRkMB4XDTE0MDQxNjAxNTMxNloXDTE0MDUxNjAxNTMxNlowRTELMAkG
A1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0
IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
ALjMckivuEoPFVxRFfxPAnWcdx4XjT8RGAeSRXnIG5y4NvcxffE8Een4ahtP4Zm0
xF+8RLVXz8Z/gDMNt+vaNWSXow6W7gr5LO3h7nX76FtxYNpnlxMjy9rIpSFftaYI
OP/TZ2882OSP+yXcFzu4AppLim37r2PK1CQJCkiq4YRhnZtE5jjjq3UYMh4aybII
CLIZxLvtw+cftCqIhHNdWvZqqXKKCwMOS/BxDnTYqoDVvVixxBmiiYmbdGSK4Gkc
KgzUiGn1tyWekY8dsuxNPPvbOfCW4CbcJXMCqtv4qLb5X+PN9lbG8pzSWgfc451D
Uu7PFmjOE62mrfJ5ijr9lHsCAwEAATANBgkqhkiG9w0BAQUFAAOCAQEAdiaBw4Af
By3Ar4ZF1RUPJOiSRMZuUk7+Cd9oaCK2OoDoV6zVw9L8Ry8c61+3ddDrIqRYUB6e
g2eGgpukoMqAu0CG/wJTb5kPY59SN0hNsfWVvGEv/y/6DKz1jkIk0zTt4Nj+XrA1
WG+1VW9UoVtoRobz+TLCYMpA38UdJkFMVYH02UI4JraNBqvdffy8zWh24lO9G0WI
FqkSDk+0xul79IIM1qFoOuty7hMx2ngJ3BKRawNJJuZhjKBGP5ThJNYm5Ek1r5VC
mNz7901Hj0y/UAOz4OqRMQ4aS/AymF0VJi2YG49gIekRSJw2hqefLuRDaSphjROt
5msGFpE+rJWa4Q==
-----END CERTIFICATE-----
EOF

echo "start script:" $(date +"%y-%m-%d %H:%M:%S")
for day in $days
do
	for project in ${projects[@]}
	do
		fullname=`echo $project | awk -F: '{print $1}'`
		projectname=`echo $project | awk -F: '{print $2}'`
		logfile="access-$day-$projectname-all.log.tar.gz"
		if [ -f "$newlog/$projectname/$logfile" ]; then
			cd $newlog/$projectname
			echo "Backing up $fullname"
		        if [ -f ${logfile}.rar ]; then
		                rm -f ${logfile}.rar
		        fi
		        magic=`openssl rand -hex 32`
		        pw=$RANDOM$RANDOM`openssl rand -hex 64`
		        echo $pw | openssl smime -encrypt -aes256 -binary -outform DER ${cert_file} > enc.${magic}.bkey
		        /usr/local/bin/rar a ${logfile}.rar enc.${magic}.bkey -y > /dev/null
		        openssl enc -aes-256-cbc -salt -in "${logfile}" -k $pw > enc.${magic}.raw
		        /usr/local/bin/rar a ${logfile}.rar -m5 enc.${magic}.raw -y > /dev/null
			archive_id=$(glacier-cmd upload ${glacier_vault} ${logfile} | sed -n '4p' | awk -F'|' '{print $3}')
			echo ${logfile} ${archive_id} | tee -a ${uploadlog}
		        rm -fr enc.${magic}.bkey enc.${magic}.raw
		        pw=0
		else
			echo "warning: ${logfile} file not found"
		fi
	done
done
