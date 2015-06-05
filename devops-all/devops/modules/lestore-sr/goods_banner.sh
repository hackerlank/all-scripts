#! /bin/bash

total=20

for i in $(seq -w 0 $(($total-1))); do
        label="73b9118abe628e3410c5724b88f70afd_${total}_${i}"
        #running=$(ps aux|grep $label|grep 'bash -c '|grep -v 'grep'|wc -l)
        echo -e "---- ps aux|grep $label\n$(ps aux|grep $label)"
        echo -e "---- ps aux|grep $label|grep -v 'grep'\n$(ps aux|grep $label|grep -v 'grep')"
        echo -e "---- ps -ef|grep $label|grep -v 'grep'\n$(ps -ef|grep $label|grep -v 'grep')"
        echo -e "---- ps aux|grep $label|grep -v 'grep'|wc -l\n$(ps aux|grep $label|grep -v 'grep'|wc -l)"
        running=$(ps aux|grep $label|grep -v 'grep'|wc -l)
        if [ "$running" -gt 1 ]; then
                continue
        fi
		/var/job/goods_banner_multi.sh $total $i 73b9118abe628e3410c5724b88f70afd_${total}_${i} >> /opt/data1/log/goods_banner_multi_${total}_${i}-$(date +%Y%m%d).log 2>&1 &
done
