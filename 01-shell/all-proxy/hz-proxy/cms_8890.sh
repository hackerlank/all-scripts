#!/bin/bash

while true; do
	curl -k --connect-timeout 10 -m 10 --proxy 127.0.0.1:8890 -w %{speed_download}:%{time_starttransfer}:%{time_total}:%{size_download} -o /dev/null -s -L https://cms.jenjenhouse.com/resource/images/ipad.jpg >> jenjen_8890
	echo -ne '\n' >> jenjen_8890
	curl -k --connect-timeout 10 -m 10 --proxy 127.0.0.1:8890 -w %{speed_download}:%{time_starttransfer}:%{time_total}:%{size_download} -o /dev/null -s -L https://cms.jjshouse.com/resource/images/ipad.jpg >> jjs_8890
	echo -ne '\n' >> jjs_8890
	sleep 10
done
