#!/bin/bash
### BEGIN INIT INFO
# Provides:	         httpstatus
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts httpstatus
# Description:       starts httpstatus using start-stop-daemon
### END INIT INFO

# https://stackoverflow.com/questions/6136022/script-to-get-the-http-status-code-of-a-list-of-urls
# modified by:	maravento.com and novatoz.com

# PATH FILE (change path to your list) (Optional)
list=~/folder/list.txt
# CLEAN LIST
sed -e '/^#/d' $list | sed -r '/^.\W+/d' | sed 's/^.//g' | sed '/[A-Z]/d' | sort -u > tmp
# HTTPSTATUS
while read LINE; do
  curl -o /dev/null --silent --head --write-out '%{http_code}' "$LINE"
  echo " $LINE" 
done < tmp | sed '/^000/d' | awk '{print $2}' | awk '{print "."$1}' | sort -u > newlist.txt
