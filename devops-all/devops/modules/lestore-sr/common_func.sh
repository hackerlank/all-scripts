function fetch(){
    path=$(dirname $1)
    mkdir -p $path
    chown -R www-data.www-data $path
    rsync -a -K --progress -e "ssh -p$fetch_port" $fetch_host:$1 $1
}

function check_and_fetch(){
	src=$1
    if [ ! -f "$src" ]; then
        fetch "$src"
        if [ ! -f "$src" ]; then
            echo "SRC $src not found."
            return 2;
        else
            echo "SRC $src fetched."
        fi
    fi
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
    fi
    echo $dest
}


