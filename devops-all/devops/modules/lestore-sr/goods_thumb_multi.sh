#! /bin/bash
:<<EOF
By Zandy
EOF

logname=img_$(date +%F_%H)
logdir="/mnt/data1/jjsimg/imggen"
mkdir -p ${logdir}
upimglog="${logdir}/${logname}.log"
updir=up_$(date +%F)
upimgdir="/mnt/data1/jjsimg/imgup/${updir}/"
mkdir -p ${upimgdir}

chushu=$1
yushu=$2

label="86bf265ccd81ea7f23b37c15f496dda7_${chushu}_${yushu}"

#running=$(ps aux|grep $label|grep 'bash -c '|grep -v 'grep'|wc -l)
###echo -e "---- ps aux|grep $label\n$(ps aux|grep $label)"
###echo -e "---- ps aux|grep $label|grep -v 'grep'\n$(ps aux|grep $label|grep -v 'grep')"
###echo -e "---- ps -ef|grep $label|grep -v 'grep'\n$(ps -ef|grep $label|grep -v 'grep')"
###echo -e "---- ps aux|grep $label|grep -v 'grep'|wc -l\n$(ps aux|grep $label|grep -v 'grep'|wc -l)"
running=$(ps aux|grep $label|grep -v 'grep'|wc -l)
if [ "$running" -gt 2 ]; then
        echo "$(ps aux|grep $label|grep 'bash -c '|grep -v 'grep')"
        echo "already running $0  $label($running) $(date +'%Y-%m-%d %T')"
        exit 1
fi

dbhost=jjshousedb.cmyicoxavsy8.us-east-1.rds.amazonaws.com
dbname=jjshouse
dbuser=
dbpass=

###mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname;insert ignore into goods_thumb (goods_id, img_id, thumb_name, width, height, watermark) SELECT gg.goods_id, gg.img_id, c.thumb_name, c.width, c.height, watermark FROM goods_gallery gg, goods_thumb_config c WHERE gg.img_type = c.img_type"

goods=$(mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname;SELECT gt.goods_thumb_id, gt.goods_id, gt.img_id, gt.thumb_name, gt.width, gt.height, gt.watermark, gg.img_url, img_original, gg.img_type FROM goods_thumb gt left join goods_gallery gg on gt.img_id = gg.img_id WHERE gt.has_done = 0 AND goods_thumb_id%$chushu = $yushu ORDER BY goods_thumb_id LIMIT 500 ")
#goods_thumb_id goods_id        img_id  thumb_name      width   height  watermark       img_url img_original
total=$(echo "$goods" | wc -l)
echo "total: $total"
echo "$goods" | while read row; do
        #if [ "$iii" = "" -o "$iii" -lt 1 ]; then
        if [ "$iii" = "" ]; then
                iii=0
        fi
        (( iii++ ))
        echo "tota: $total current: $iii"
        goods_id=$(echo "$row"|awk -F"\t" '{print $2}')
        echo $goods_id|grep -E '^[0-9]+$' > /dev/null
        if [ $? -eq 0 ]; then
                goods_thumb_id=$(echo "$row"|awk -F"\t" '{print $1}')
                img_id=$(echo "$row"|awk -F"\t" '{print $3}')
                thumb_name=$(echo "$row"|awk -F"\t" '{print $4}')
                width=$(echo "$row"|awk -F"\t" '{print $5}')
                height=$(echo "$row"|awk -F"\t" '{print $6}')
                watermark=$(echo "$row"|awk -F"\t" '{print $7}'|tr "[A-Z]" "[a-z]")
                img_url=$(echo "$row"|awk -F"\t" '{print $8}')
                img_original=$(echo "$row"|awk -F"\t" '{print $9}')
                img_type=$(echo "$row"|awk -F"\t" '{print $10}')

                thumb=$img_url
                ori=$img_original

                ori_img="/opt/data1/jjsimg/$ori"
                #upimgdir="/mnt/data1/jjsimg/upimg/"
                #mkdir -p $upimgdir

                if [ -n "$watermark" ]; then
                        if [ "$watermark" = "jjshouse" -o "$watermark" = "jenjenhouse" -o "$watermark" = "jennyjoseph" -o "$watermark" = "amormoda" -o "$watermark" = "dressdepot" -o "$watermark" = "dressfirst" -o "$watermark" = "vbridal" ]; then
                                dst_img="${upimgdir}$watermark/$thumb_name/$thumb"
                        else
                                echo "unkown $watermark";
                                continue
                        fi
                else
                        dst_img="${upimgdir}$thumb_name/$thumb"
                fi

                #if [ -f $dst_img ]; then
                #       echo "$dst_img is exists."
                #       if [ "$goods_thumb_id" -gt 0 -a -f $dst_img ]; then
                #               mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname;UPDATE goods_thumb SET has_done = 1 WHERE goods_thumb_id = $goods_thumb_id LIMIT 1 "
                #       fi
                #       continue
                #fi

                dst_dir=${dst_img%/*}
                echo $ori_img, $dst_img, $dst_dir
                test -d "$dst_dir" || mkdir -p "$dst_dir"

                if [ -n "$watermark" -a "$img_type" = "design" ]; then
                        watermark_design="/var/job/jjshouse/${watermark}.design.png"
                        composite -gravity center -geometry +0+0 $watermark_design "$ori_img" "$dst_img"
                elif [ -n "$watermark" ]; then
                        watermark_design="/var/job/jjshouse/${watermark}.design.png"
                        watermark_logo_700="/var/job/jjshouse/${watermark}.com_logo_700.png"
                        watermark_logo_3072="/var/job/jjshouse/${watermark}.com_logo_3072.png"
                        if [ "$img_type" = "old" ]; then
                                watermark_logo_700="/var/job/jjshouse/${watermark}.com_logo_s_700.png"
                                watermark_logo_3072="/var/job/jjshouse/${watermark}.com_logo_s_3072.png"
                        fi
                        if [ "$thumb_name" = "m" ]; then
                                watermark_logo=$watermark_logo_700
                        else
                                watermark_logo=$watermark_logo_3072
                        fi
                        if [ "$thumb_name" = "o" ]; then
                                /bin/cp -f "$ori_img" "$dst_img"
                        else
                                #convert -resize $max_width\> -strip -quality 80 $ori_img $dst_img
                                convert -resize $width\> -strip "$ori_img" "$dst_img"
                                if [ $? -gt 0 ]; then
                                        echo "convert -resize $width\> -strip \"$ori_img\" \"$dst_img\"; # failed" >> /opt/data1/log/resize.log
                                        echo "composite -gravity center -geometry +0+0 $watermark_logo_700 \"$dst_img\" \"$dst_img\"" >> /opt/data1/log/resize.log
                                        echo "composite -gravity center -geometry +0+0 $watermark_logo_3072 \"$dst_img\" \"$dst_img\"" >> /opt/data1/log/resize.log
                                        continue
                                fi
                        fi
                        a=$(identify "$dst_img" | awk '{print $3}')
                        b=`echo $a|awk -F "x" '{print $1}'`
                        c=`echo $a|awk -F "x" '{print $2}'`
                        if [ "$watermark" = "jjshouse" ]; then
                                if [ "$b" -gt 240 ] && [ "$c" -gt 240 ]; then
                                        #composite -gravity center -geometry +0+100 /var/job/jjshouse/${watermark}_logo.png $dst_img $dst_img
                                        composite -gravity center -geometry +0+0 $watermark_logo "$dst_img" "$dst_img"
                                        if [ "$thumb_name" = "x" ]; then
                                        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "Copyright © JJsHouse.com Studio" "$dst_img"
                                        fi
                                        echo $dst_img
                                else
                                        echo "lt 240 $watermark"
                                fi
                        elif [ "$watermark" = "jenjenhouse" ]; then
                                if [ "$b" -gt 240 ] && [ "$c" -gt 240 ]; then
                                        composite -gravity center -geometry +0+0 $watermark_logo "$dst_img" "$dst_img"
                                        if [ "$thumb_name" = "x" ]; then
                                        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "Copyright © JenJenHouse.com Studio" "$dst_img"
                                        fi
                                        echo $dst_img
                                else
                                        echo "lt 240 $watermark"
                                fi
                        elif [ "$watermark" = "jennyjoseph" ]; then
                                if [ "$b" -gt 240 ] && [ "$c" -gt 240 ]; then
                                        composite -gravity center -geometry +0+0 $watermark_logo "$dst_img" "$dst_img"
                                        if [ "$thumb_name" = "x" ]; then
                                        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "Copyright © JennyJoseph.com Studio" "$dst_img"
                                        fi
                                        echo $dst_img
                                else
                                        echo "lt 240 $watermark"
                                fi
                        elif [ "$watermark" = "amormoda" ]; then
                                if [ "$b" -gt 240 ] && [ "$c" -gt 240 ]; then
                                        composite -gravity center -geometry +0+0 $watermark_logo "$dst_img" "$dst_img"
                                        if [ "$thumb_name" = "x" ]; then
                                        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "Copyright © AmorModa.com Studio" "$dst_img"
                                        fi
                                        echo $dst_img
                                else
                                        echo "lt 240 $watermark"
                                fi
                        elif [ "$watermark" = "dressdepot" ]; then
                                if [ "$b" -gt 240 ] && [ "$c" -gt 240 ]; then
                                        composite -gravity center -geometry +0+0 $watermark_logo "$dst_img" "$dst_img"
                                        if [ "$thumb_name" = "x" ]; then
                                        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "Copyright © DressDepot.com Studio" "$dst_img"
                                        fi
                                        echo $dst_img
                                else
                                        echo "lt 240 $watermark"
                                fi
                        elif [ "$watermark" = "dressfirst" ]; then
                                if [ "$b" -gt 240 ] && [ "$c" -gt 240 ]; then
                                        composite -gravity center -geometry +0+0 $watermark_logo "$dst_img" "$dst_img"
                                        if [ "$thumb_name" = "x" ]; then
                                        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "Copyright © DressFirst.com Studio" "$dst_img"
                                        fi
                                        echo $dst_img
                                else
                                        echo "lt 240 $watermark"
                                fi
                        elif [ "$watermark" = "vbridal" ]; then
                                if [ "$b" -gt 240 ] && [ "$c" -gt 240 ]; then
                                        composite -gravity center -geometry +0+0 $watermark_logo "$dst_img" "$dst_img"
                                        if [ "$thumb_name" = "x" ]; then
                                        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "Copyright © VBridal.com Studio" "$dst_img"
                                        fi
                                        echo $dst_img
                                else
                                        echo "lt 240 $watermark"
                                fi
                        else
                                echo "unkown $dst_img";
                                continue
                        fi
                elif [ "$thumb_name" = "ls" ]; then
                        convert "$ori_img" -thumbnail "x${height}>" -gravity center -extent ${width}x${height} "$dst_img"
                        if [ $? -gt 0 ]; then ls -l "$ori_img"; fi
                elif [ "$thumb_name" = "rs" ]; then
                        convert "$ori_img" -thumbnail ${width}x${height}^ -background gray -gravity North -extent ${width}x${height} "$dst_img"
                        #echo "convert \"$ori_img\" -thumbnail ${width}x${height}^ -background gray -gravity North -extent ${width}x${height} \"$dst_img\""
                        if [ $? -gt 0 ]; then ls -l "$ori_img"; fi
                else
                        convert "$ori_img" -resize ${width}x${height}\> -size ${width}x${height} xc:white +swap -gravity North -composite "$dst_img"
                        #echo $dst_img
                        if [ $? -gt 0 ]; then ls -l "$ori_img"; fi
                fi

                if [ "$goods_thumb_id" -gt 0 -a -f $dst_img ]; then
                        mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname;UPDATE goods_thumb SET has_done = 1 WHERE goods_thumb_id = $goods_thumb_id AND has_done = 0 LIMIT 1 "
                        echo $dst_img >> $upimglog
                fi
        fi
done

echo "total: $total"
