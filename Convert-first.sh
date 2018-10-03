#!/bin/bash

############################################################
#                   MKV script Converter
#
#   Convert MKV file whith 720p preset conversion
#
# 	Convert /full/path/to/file.mkv
# 
#   (c) 2018, Edoardo Marchetti <marchetti.edoardo@gmail.com>
#   https://github.com/jas31085/Handbracke-cli-Converter
# 
############################################################



# full film Path
RemoteMKV="$1"

HANDBRAKE="$(which HandBrakeCLI)"

# Nome del file
NAME="$(echo "$RemoteMKV" | awk -F"/" '{ print $NF}')"

# conversion tmp folder
LocalMKV="/tmp/$NAME"

# FolderOrigin
FolderOrigin="$(echo $RemoteMKV | awk -v name="$NAME" '{ gsub(name, "") ; print $0 }')"

# Local filename
TempM4V="/video/$NAME.m4v"

# Preset HandBrake
#PRESET="Apple TV 2"
PRESET="-e x264 -q 20.0 -r 30 --pfr  -a 1,1 -E ffaac,copy:ac3 -B 160,160 -6 dpl2,none -R Auto,Auto -D 0.0,0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4 -X 1280 -Y 720 --decomb=fast --loose-anamorphic --modulus 2 -m -O --x264-preset medium --h264-profile high --h264-level 4.0"

echo "Start Processing File  " $(date) 
echo ""

# moving the file locally (only if the source is on the network and with SSD)
cp "$RemoteMKV" "/video/$NAME"

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
