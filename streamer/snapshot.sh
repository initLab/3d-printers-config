#!/bin/bash

# Logitech C200 camera produces JPEG files without Huffman tables
# Logitech QuickCam Pro 5000 seems to do something similar
PORT="${1}"
NAME="${2}"
URL=http://127.0.0.1:"${PORT}"/snapshot.jpeg
FILENAME=/tmp/snapshot-"${NAME}".jpeg

# Comment these two to enable debugging
CURL_OPT=-s
JPEGOPTIM_QUIET=-q

# Verbose cURL
#CURL_OPT=-v

while [ 1 ]
do
	curl $CURL_OPT -f -o $FILENAME $URL && \
	jpegoptim $JPEGOPTIM_QUIET $FILENAME
	sleep 1
done
