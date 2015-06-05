#!/bin/bash

sf=$1
df=$2
if [ -f $sf ]; then

        if [ -f $df ]; then
                rm -i $df
        fi

        # Use magic number to avoid name conflict
        magic=`openssl rand -hex 32`
        pw=$RANDOM$RANDOM`openssl rand -hex 64`


        echo $pw | openssl smime -encrypt -aes256 -binary -outform DER /etc/ssl/ssd_cert.pem > enc.$magic.bkey
        openssl enc -aes-256-cbc -salt -in "$sf" -k $pw > enc.$magic.raw
        pw=0
        echo $pw

        /usr/local/bin/rar a -m0  $df enc.$magic.bkey enc.$magic.raw

        rm -rf enc.$magic.bkey enc.$magic.raw

else
        echo $sf does not exist
fi
