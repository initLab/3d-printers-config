#!/bin/bash

# Update files in the repository with the files found on the octoprint server

set -e
set -x

OCTOPRINT_HOST="${OCTOPRINT_HOST:-octopi.remote}"
SANITIZE=${SANITIZE:-y}

# printers
for printer in mendel a8 i3mega; do
    scp "root@$OCTOPRINT_HOST":/home/octoprint.$printer/.octoprint/config.yaml octoprint-configs/$printer/
    scp -r "root@$OCTOPRINT_HOST":/home/octoprint.$printer/.octoprint/slicingProfiles/ octoprint-configs/$printer/
    scp -r "root@$OCTOPRINT_HOST":/home/octoprint.$printer/.octoprint/printerProfiles/ octoprint-configs/$printer/
    ssh "root@$OCTOPRINT_HOST" "crontab -u octoprint.$printer -l | grep -v '^#'" > octoprint-configs/$printer/cron.txt
    scp -r "root@$OCTOPRINT_HOST":/home/octoprint.$printer/start.sh octoprint-configs/$printer/
    scp -r "root@$OCTOPRINT_HOST":/home/octoprint.$printer/restart.sh octoprint-configs/$printer/
done

# web
scp "root@$OCTOPRINT_HOST":/etc/nginx/sites-enabled/octoprint nginx/octoprint.conf
scp -r "root@$OCTOPRINT_HOST:/home/web/public/*" web/

# streamer
ssh "root@$OCTOPRINT_HOST" "crontab -u streamer -l | grep -v '^#'" > streamer/cron.txt
scp -r "root@$OCTOPRINT_HOST":/home/streamer/start.sh streamer/
scp -r "root@$OCTOPRINT_HOST":/home/streamer/snapshot.sh streamer/

if [ $SANITIZE = 'y' ]; then
    # NOTE: this is very rudimentary and not exactly 100% accurate but gets the job done
    #       there should be a person reviewing the changes anyway
    sed -i 's/:\/\/[^/]*\/api/:\/\/SECRET\/api/g' octoprint-configs/*/config.yaml
    sed -i 's/apikey=[a-z0-9A-Z]*/apikey=SECRET/g' octoprint-configs/*/config.yaml
    sed -i 's/token: [a-zA-Z0-9:-]*/token: SECRET/g' octoprint-configs/*/config.yaml
    sed -i '/^ *secretKey: /d' octoprint-configs/*/config.yaml
    sed -i '/^ *unique_id: /d' octoprint-configs/*/config.yaml
    sed -i -z 's/\napi:\n *key: \w*\n/\n/' octoprint-configs/*/config.yaml
    sed -i -z 's/\n *discovery:\n *upnpUuid: [^\n]*\n/\n/' octoprint-configs/*/config.yaml
fi

echo 'Please review diff for sensitive data before pushing!'
