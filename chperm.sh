#!/bin/sh

# change permissions of files and directories recursively in path

dirr="/path/to/dir"
chown -R user:users $dirr
find $dirr -type d -exec chmod 777 {} \;
find $dirr -type f -exec chmod 666 {} \;
