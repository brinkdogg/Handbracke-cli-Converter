#!/bin/bash

############################################################
#                   MKV script Converter
#
#   Convert MKV file whith Handbracke-cli
#
# 
# Usage: Convert -f /full/path/to/file.mkv [-l /local/folder/] [-p "preset"]
#     -f, --file 				mkv File
#     -l, --local 				local folder if you use SSD disk [default=/tmp/]
# 	  -p, --preset 				Preset for conversion
#     -h, --help 				Display this screen
#
# 
# (c) 2018, Edoardo Marchetti <marchetti.edoardo@gmail.com>
# https://github.com/jas31085/Handbracke-cli-Converter
#



if [[ $# -eq 0 ]] ; then
	sed -n '2,17p' "$0" | tr -d '#'
	exit 3
fi

if [[ -e "$(which HandBrakeCLI)" ]]; then
	HANDBRAKE="$(which HandBrakeCLI)"
else
	echo "ERROR: Install HandBrakeCLI"
	exit 3
fi

while [[ -n "$1" ]]; do
  case $1 in
    --file | -f)
		if [[ -e $2 ]]; then
			# full film Path
			RemoteMKV="$2"
			NAME="$(echo "$RemoteMKV" | awk -F"/" '{ print $NF}')"
			FolderOrigin="$(echo $RemoteMKV | awk -v name="$NAME" '{ gsub(name, "") ; print $0 }')"
		else
			echo "ERROR: the file doesn't exist"
			exit 3
		fi
      shift
      ;;
    --local | -l)
		if [[ -d "$2" ]]; then
			LocalMKV="$2$NAME"
		else
			echo "ERROR: the local temp doesn't exist"
			exit 3
		fi
      shift
      ;;
    --preset | -p)
		PRESET="$2"
      shift
      ;;
    --help | -h | *)
      sed -n '2,17p' "$0" | tr -d '#'
      exit 3
      ;;
  esac
  shift
done

# conversion tmp folder
if [[ -z "$LocalMKV" ]]; then
	LocalMKV="/tmp/$NAME"
fi

# Local filename
TempM4V="$LocalMKV.m4v"


# Preset HandBrake
if [[ -z "$PRESET" ]]; then
	PRESET="-e x264 -q 20.0 -r 30 --pfr  -a 1,1 -E ffaac,copy:ac3 -B 160,160 -6 dpl2,none -R Auto,Auto -D 0.0,0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4 -X 1280 -Y 720 --decomb=fast --loose-anamorphic --modulus 2 -m -O --x264-preset medium --h264-profile high --h264-level 4.0"
fi

echo "Start Processing File  " $(date) 
echo ""

# moving the file locally (only if the source is on the network and with SSD)
cp "$RemoteMKV" "$LocalMKV"

# conversion task 
$HANDBRAKE -v -i "$LocalMKV" $PRESET -o "$TempM4V"

# moving the file to the original position
cp "$TempM4V" "$FolderOrigin"

# delete tmp file
if [[ -e "$TempM4V" ]]; then
 	rm -rf "$TempM4V" 
fi

# delete mkv file
# if [[ -e "$RemoteMKV" ]]; then
# 	rm -rf "$RemoteMKV"
# fi

# delete local mkv
if [[ -e "$LocalMKV" ]]; then
	rm -rf "$LocalMKV"
fi

echo "Stop Processing File  " $(date)
echo ""
