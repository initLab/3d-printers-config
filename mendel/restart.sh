#!/bin/bash

start-stop-daemon --stop --retry=TERM/30/KILL/5 --user $USER --exec ~/octoprint/bin/python2 && \
~/start.sh
