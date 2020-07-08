# General System Preparations #

```sh
sudo apt update
sudo apt install python python-dev python-virtualenv
sudo apt install vim-nox mc git screen tmux

# TODO: add more stuff

# TODO: nginx conf
```

# Steps for Installing a New Printer #

## Home Directory ##

Substitute `PRINTER_NAME` and `PORT` appropriately.

```sh
# create new user
sudo useradd -m -s /bin/bash octoprint.PRINTER_NAME`

# add the new printer to `udev-rules.d/99-octoprint.rules`
vim /etc/udev-rules.d/99-octoprint.rules
# add the new camera to `udev-rules.d/99-cameras.rules`
vim /etc/udev-rules.d/99-cameras.rules

sudo -iu octoprint.PRINTER_NAME

# create virtualenv
cd ~/
virtualenv octoprint
cd octoprint
. bin/activate

pip install octoprint  # current version is 1.4.0

PORT=5002  # the port of the printer

cat > ~/start.sh <<EOF
#!/bin/bash

screen -dm bash -c '~/octoprint/bin/octoprint serve --host 127.0.0.1 --port $PORT; sleep 60'
EOF
chmod +x ~/start.sh

crontab -e
# add:
#   @reboot /home/octoprint.PRINTER_NAME/start.sh

cat >restart.sh <<EOF
#!/bin/bash

/sbin/start-stop-daemon --stop --retry=TERM/30/KILL/5 --user $LOGNAME --exec ~/octoprint/bin/python2 && \
~/start.sh
EOF
chmod +x restart.sh
```

```sh
# as root

# edit nginx/octoprint.conf
vim /etc/nginx/sites-available/octoprint
# add the new printer and streamer, use the other printers as template
```

Restart and follow the instructions.

After the restart you might make a diff with the other configurations and install plugins.

## Plug-ins ##

Plug-ins to install:
  - PSU Control
  - OctoPrint-Slic3r
  - Full-featured Slicer
  - OctoPrint-Telegram
  - Themeify
  - TouchUI

## Web Portal ##

Edit `web/index.html` and transfer it to `root@octopi.remote:/home/web/public/`

