#!/bin/bash

/sbin/start-stop-daemon --stop --retry=TERM/30/KILL/5 --user $LOGNAME --exec ~/octoprint/bin/python2 && \
~/start.sh
