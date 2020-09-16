#!/bin/bash

DEVICE="/dev/video-$1"
shift

while [ 1 ]
do
	~/uvc-streamer/uvc_stream --device "${DEVICE}" "$@"
	sleep 1
done
