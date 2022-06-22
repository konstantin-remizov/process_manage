#!/bin/bash

clk_tck=`getconf CLK_TCK`

(
echo "PID|TTY|STAT|TIME|COMMAND";
for pid in `ls /proc | grep -E "^[0-9]+$"`; do
    if [ -d /proc/$pid ]; then
        stat=`</proc/$pid/stat`

        tty=`echo "$stat" | awk -F" " '{print $7}'`
        state=`echo "$stat" | awk -F" " '{print $3}'`
        cmd=`echo "$stat" | awk -F" " '{print $2}'`
        utime=`echo "$stat" | awk -F" " '{print $14}'`
        stime=`echo "$stat" | awk -F" " '{print $15}'`
        ttime=$((utime + stime))
        time=$((ttime / clk_tck))

        echo "${pid}|${tty}|${state}|${time}|${cmd}"
    fi
done
) | column -t -s "|"
