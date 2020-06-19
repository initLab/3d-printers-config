#!/bin/bash

PROG=/home/streamer/uvc-streamer/uvc_stream

while [ 1 ]
do
        $PROG --device "/dev/video-$1" --resolution "$2" --fps 30 -q 100 --port "$3"
        sleep 1
done
