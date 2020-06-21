#!/bin/bash

while [ 1 ]
do
	DEVICE="/dev/video-$1"
	shift
	~/uvc-streamer/uvc_stream --device "${DEVICE}" "$@"
	sleep 1
done
