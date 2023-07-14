#!/bin/bash

# rsync of whole Linux system to snapshot directory

rsync -aAXv / --exclude={"/dev/*","/proc/*","/srv/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} /mnt/snapshots/local > /mnt/snapshots/local.log
