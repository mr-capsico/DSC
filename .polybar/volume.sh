#!/bin/bash
percent=$( pactl list sinks | grep '^[[:space:]]Volume:' | \
	    head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

icons=(婢 奄 奔 墳 )
max=30
if [[ $percent == 0 ]]; then
                echo ${icons[0]}
elif [[ $percent -le $((max/4)) ]]; then
                echo ${icons[1]}
elif [[ $percent -le $((max/2)) ]]; then
                echo ${icons[2]}
elif [[ $percent -le $(((max/2)+(max/4))) ]]; then
                echo ${icons[3]}
else
                echo ${icons[4]}
fi
