#! /bin/bash

:<<EOF
by Zandy
EOF

phpcmd="/usr/local/bin/php"

if [[ -f $(dirname $0)/host_name.conf ]]
then
        source $(dirname $0)/host_name.conf
else
        host_name=$(hostname)
fi

aws_name=`curl http://169.254.169.254/latest/meta-data/public-hostname`

if [[ ! -z $aws_name ]]
then
        host_name=$aws_name@$host_name
fi

langs=$($phpcmd /var/www/http/lestore/application/export_lang.php all)
for project_name in JJsHouse JenJenHouse JennyJoseph AmorModa DressDepot; do
for lang in $langs; do
        lang_file="/var/www/http/lestore/application/languages/$(echo $project_name|tr 'A-Z' 'a-z')_${lang}.php"
        export_lang=$($phpcmd /var/www/http/lestore/application/export_lang.php $lang no $project_name)
        echo "$export_lang" | grep -q '^\/\/ok'
        if [ $? -eq 0 ] && [ "$export_lang" != "error" ]; then
                echo "$export_lang" > $lang_file.tmp
                $phpcmd -l $lang_file.tmp
                if [ $? -gt 0 ]; then
                        printf %b "Level: Sev-1 \nInfo: $project_name export $lang language file failed. \nHost:$host_name \nDate: $(date +'%Y-%m-%d %T') "|mail -s "[Sev-1] AWS Alert: $host_name export $lang language file failed" alarm@i9i8.com 
                fi
		cp -f $lang_file.tmp $lang_file
        else
                printf %b "Level: Sev-1 \nInfo: $project_name export $lang language file failed. \nHost:$host_name \nDate: $(date +'%Y-%m-%d %T') "|mail -s "[Sev-1] AWS Alert: $host_name export $lang language file failed" alarm@i9i8.com
                exit 1
        fi
done
done
