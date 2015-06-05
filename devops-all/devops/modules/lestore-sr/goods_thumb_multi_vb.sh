#!/bin/bash

###
# Mutual exclusive execution
###
chushu=$1
yushu=$2

source $(dirname $0)/ssh-agent.sh
source $(dirname $0)/sr_thumb.conf

label="86bf265ccd81ea7f23b37c15f496dda7_${chushu}_${yushu}"
running=$(ps aux|grep $label|grep -v 'grep'|wc -l)
if [ "$running" -gt 2 ]; then
        echo "$(ps aux|grep $label|grep 'bash '|grep -v 'grep')"
        echo "already running $0  $label($running) $(date +'%Y-%m-%d %T')"
        exit 1
fi

###
# Global configuration
###
#WATERMARK_PATH="/Users/blu3gui7ar/work/exported/logos/testbed/watermark"
#SRC_PATH="/Users/blu3gui7ar/work/exported/logos/testbed/org"
#DEST_PATH="/Users/blu3gui7ar/work/exported/logos/testbed/output"
#LOG_PATH="/Users/blu3gui7ar/work/exported/logos/testbed/log"
#dbhost=localhost
#dbhost_ro=localhost
#dbname=jjshouse
#dbuser=jjshouse
#dbpass=jjshouse

WATERMARK_PATH='/var/job/watermarks'
SRC_PATH='/opt/data1/jjsimg'
DEST_PATH='/mnt/data1/jjsimg/imgup'
LOG_PATH='/mnt/data1/jjsimg/imggen'

mysql_ro="mysql --skip-column-names --default-character-set=utf8 -h$dbhost_ro -u$dbuser -p$dbpass $dbname"
mysql="mysql --skip-column-names --default-character-set=utf8 -h$dbhost -u$dbuser -p$dbpass $dbname"
#fetch from js-cms: ec2-50-16-230-173.compute-1.amazonaws.com
#fetch_port=32200


logname=img_$(date +%F_%H)
mkdir -p $LOG_PATH
upimglog="$LOG_PATH/${logname}.log"
updir=up_$(date +%F)
upimgdir="$DEST_PATH/${updir}"
mkdir -p ${upimgdir}

function fetch(){
    path=$(dirname $1)
    mkdir -p $path
    chown -R www-data.www-data $path
    if [[ $path == *$DEST_PATH* ]]; then
        chown -R www-data.www-data $(dirname $path)
        chown -R www-data.www-data $(dirname $(dirname $path))
    fi
    rsync -a --progress -e "ssh -p$fetch_port" $fetch_host:$1 $1
}

function resize(){
    outsize=$1
    src=$2
    dest=$3

    rs=0
    if [ $outsize == '0' ] && [ "$src" != "$dest" ]; then
        cp -f "$src" "$dest"
    elif [ $outsize != '0' ]; then
        convert -resize $outsize -strip "${src}" "${dest}"
        chown www-data:www-data "$dest"
        rs=$?
        if [ $rs -gt 0 ]; then
            echo "convert -resize $outsize -strip \"$src\" \"$dest\"; # failed"
        fi
    fi
    return $rs
}

function prepare_logo(){
    watermark=$1
    thumb_name=$2
    src_x=$3
    src_y=$4

    rs=0
    if [ "$src_x" -le 240 ] || [ "$src_y" -le 240 ]; then
        #no watermark
        return
    elif [ "$thumb_name" == 'x' ]; then
        #string watermark
        case $watermark in
            'jjshouse')
                site='JJsHouse';
                ;;
            'jenjenhouse')
                site='JenJenHouse';
                ;;
            'jennyjoseph')
                site='JennyJoseph';
                ;;
            'dressfirst')
                site='DressFirst';
                ;;
            'dressdepot')
                site='DressDepot';
                ;;
            'amormoda')
                site='AmorModa';
                ;;
            'vbridal')
                site='VBridal';
                ;;
            'loveprom')
                site='LoveProm';
                ;;
            'azazie')
                site='Azazie';
                ;;
        esac
        echo "Copyright © ${site}.com Studio";
    else
        #logo watermark
        logo="$WATERMARK_PATH/gen/${watermark}-${src_x}.gen.png"
        if [ ! -f $logo ];then
            mkdir -p "$WATERMARK_PATH/gen/"
            size='1500x2055';
            logo_src="$WATERMARK_PATH/${watermark}-${size}.png"
            resize ${src_x}x${src_y}^ "$logo_src" "$logo"
            rs=$?
        fi
        echo $logo;
    fi
    return $rs
}

function mark(){
    logo=$1
    src=$2
    dest=$3

    if [ -n "$(echo $logo | grep 'Copyright ')" ]; then
        mogrify -pointsize 32 -fill white -weight bolder -gravity south -annotate -0+16 "$logo" "$dest"
    elif [ -n "$logo" ]; then
        composite -gravity center -geometry +0+0 $logo "$src" "$dest"
        chown www-data:www-data "$dest"
    fi
    echo $dest
}

function process(){
    watermark=$1
    img_type=$2
    thumb_name=$3
    width=$4
    height=$5
    src=$6
    dest=$7

    rs=0

    if [ ! -f "$src" ]; then
        fetch "$src"
        if [ ! -f "$src" ]; then
            echo "SRC $src not found."
            return 2;
        else
            echo "SRC $src fetched."
        fi
    fi

    format=$(identify "$src" | head -n 1 | awk '{print $2}')
    if [ "$format" == 'GIF' ]; then
        newsrc="${src}.gif2.jpg"
        if [ ! -f "$newsrc" ]; then
            convert "$src[0]" -background white -flatten -alpha off "$newsrc"
            chown www-data:www-data "$newsrc"
        fi
        src="$newsrc"
    fi

    if [ -n "$watermark" ]; then
        if [ "$img_type" == 'design' ]; then
            logo="${watermark}.design.png"
            composite -gravity center -geometry +0+0 $logo "$src" "$dest"
            chown www-data:www-data "$dest"
        else
            size=$(identify "$src" | head -n 1 | awk '{print $3}')
            x=$(echo $size|awk -F "x" '{print $1}')
            y=$(echo $size|awk -F "x" '{print $2}')
            logo=$(prepare_logo "$watermark" "$thumb_name" "$x" "$y")

            if [ -f "$logo" ]; then
                cp "$src" "$dest"
                mark "$logo" "$dest" "$dest"
                if [ "$thumb_name" != 'o' ] && [ $width -ne 0 ]; then
                    resize ${width}\> "$dest" "$dest"
                    rs=$?
                fi
            else
                echo "WARN: logo for $watermark $thumb_name $x $y : '$logo' not found."
                filenm=${src##*/}
                http_img="http://aimg.vbridal.com/image/vb/$thumb_name/${filenm:0:2}/${filenm:2:2}/$filenm"
                curl -I $http_img
            fi
        fi
    else
        case "$thumb_name" in
            'ls')
                convert "$src" -thumbnail "x${height}>" -gravity center -extent ${width}x${height} "$dest"
                chown www-data:www-data "$dest"
                if [ $? -gt 0 ]; then ls -l "$src"; fi
                ;;
            'rs')
                convert "$src" -thumbnail ${width}x${height}^ -background gray -gravity North -extent ${width}x${height} "$dest"
                chown www-data:www-data "$dest"
                if [ $? -gt 0 ]; then ls -l "$src"; fi
                ;;
            *)
                convert "$src" -resize ${width}x${height}\> -size ${width}x${height} xc:white +swap -gravity North -composite "$dest"
                chown www-data:www-data "$dest"
                if [ $? -gt 0 ]; then ls -l "$src"; fi
                ;;
        esac
    fi
    return $rs
}

function process_thumb_row(){
    row=$1

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

        echo " goods_thumb_id: $goods_thumb_id"

        thumb=$img_url
        ori=$img_original

        ori_img="$SRC_PATH/$ori"

        ###if [ -n "$watermark" ]; then
        ###    if [ "$watermark" = "jjshouse" -o "$watermark" = "jenjenhouse" -o "$watermark" = "jennyjoseph" -o "$watermark" = "amormoda" -o "$watermark" = "dressdepot" -o "$watermark" = "dressfirst" -o "$watermark" = "vbridal" -o "$watermark" = "loveprom" -o "$watermark" = "azazie" ]; then
        ###        dst_img="${upimgdir}/$watermark/$thumb_name/$thumb"
        ###    else
        ###        echo "unkown $watermark";
        ###        continue
        ###    fi
        ###else
        ###    dst_img="${upimgdir}/$thumb_name/$thumb"
        ###fi

        # {{{ for_vb
        filename=${thumb##*/}
        dst_img="${upimgdir}/$thumb_name/${filename:0:2}/${filename:2:2}/$filename"
        # }}}

        dst_dir=${dst_img%/*}
        echo $ori_img =\> $dst_img
        test -d "$dst_dir" || (mkdir -p "$dst_dir"; chown -R www-data.www-data $dst_dir)

        process "$watermark" "$img_type" "$thumb_name" "$width" "$height" "$ori_img" "$dst_img"
        rs=$?
        echo "process result: $rs"
        if [ $rs -ne 0 ]; then
            continue
        elif [ "$goods_thumb_id" -gt 0 -a -f $dst_img ]; then
            cat <<SQL_END | $mysql
UPDATE goods_thumb SET has_done = 1 WHERE goods_thumb_id = $goods_thumb_id AND has_done = 0 LIMIT 1
SQL_END
            chown www-data.www-data $dst_img
            echo $dst_img >> $upimglog
        fi
    else
        echo "ERROR: parsing goods_id from row"
        echo $row
    fi
}


function process_by_img_id(){
    img_id=$1
    while read row; do
        if [ "$iii" = "" ]; then
                iii=0
        fi
        (( iii++ ))
        echo -n "[$iii] "
        process_thumb_row "$row"
    done <<SQL_END  | $mysql_ro
SELECT gt.goods_thumb_id, gt.goods_id, gt.img_id, gt.thumb_name, gt.width, gt.height, gt.watermark, gg.img_url, img_original, gg.img_type
FROM goods_thumb gt LEFT JOIN goods_gallery gg on gt.img_id = gg.img_id
WHERE gt.img_id=${img_id}
SQL_END
}

function process_by_goods_thumb_id(){
    goods_thumb_id=$1
    while read row; do
        if [ "$iii" = "" ]; then
                iii=0
        fi
        (( iii++ ))
        echo -n "[$iii] "
        process_thumb_row "$row"
    done <<SQL_END  | $mysql_ro
SELECT gt.goods_thumb_id, gt.goods_id, gt.img_id, gt.thumb_name, gt.width, gt.height, gt.watermark, gg.img_url, img_original, gg.img_type
FROM goods_thumb gt LEFT JOIN goods_gallery gg on gt.img_id = gg.img_id
WHERE gt.goods_thumb_id=${goods_thumb_id}
SQL_END
}

function process_images(){
    limit=$1
    thread_count=$2
    thread_no=$3
    condition=$4

    cat <<SQL_END  | $mysql_ro |
SELECT gt.goods_thumb_id, gt.goods_id, gt.img_id, gt.thumb_name, gt.width, gt.height, gt.watermark, gg.img_url, img_original, gg.img_type
FROM goods_thumb gt LEFT JOIN goods_gallery gg on gt.img_id = gg.img_id
WHERE gt.has_done = 0 AND goods_thumb_id % $thread_count = $thread_no
$condition
ORDER BY goods_thumb_id
LIMIT $limit
SQL_END
    while read row; do
        if [ "$iii" = "" ]; then
            iii=0
        fi
        (( iii++ ))
        echo -n "[$iii] "
        process_thumb_row "$row"
    done;
}

function process_by_goods_ids(){
    goods_ids="$@"
    cat <<SQL_END  | $mysql_ro | while read row; do
SELECT gt.goods_thumb_id, gt.goods_id, gt.img_id, gt.thumb_name, gt.width, gt.height, gt.watermark, gg.img_url, img_original, gg.img_type
FROM goods_thumb gt LEFT JOIN goods g on gt.goods_id = g.goods_id
WHERE g.goods_id in (${goods_ids})
AND gt.has_done = 0
SQL_END
        if [ "$iii" = "" ]; then
                iii=0
        fi
        (( iii++ ))
        echo -n "[$iii] "
        process_thumb_row "$row"
    done;
}

hour=$(date +%H)
cond=''
#if [ $hour -gt 19 ]; then
#    #4 hour for new images
#    cond='AND goods_thumb_id > 12042309 '
#fi
#process_by_img_id 201382
#process_by_goods_ids '41050,47240,45180,42367,42353,45155,47245,45154,45160,46247,46237,40840,46250,40842,27101,45183,46252,47243,47247,46239,43240,45164,44987,46259,47255,47256,47249,45167,46201,44979,45177,47242,45979,47246,45187,45178,46220,44993,47257,42713,47248,40795,47254,47244,45190,40833,42834,45211,47250,43242,44973,45000'
process_images 500 $chushu $yushu "$cond"