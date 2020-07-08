#!/bin/bash

screen -dm bash -c '~/octoprint/bin/octoprint serve --host 127.0.0.1 --port 5002; sleep 60'
