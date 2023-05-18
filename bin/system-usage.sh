#!/bin/bash

ALERT=90

<<<<<<< HEAD
message=$(df -P | awk -v ALERT="$ALERT" '
=======
diskmessage=$(df -h | awk -v ALERT="$ALERT" '
>>>>>>> d593123dd235dff3aaaf7553e3aec172bdb7d01d
    NR == 1 {next}
    $1 == "abc:/xyz/pqr" {next}
    $1 == "tmpfs" {next}
    $1 == "overlay" {next}
    $1 == "/dev/cdrom" {next}
    $1 ~ /^\/dev\/loop/ {next}
    1 {sub(/%/,"",$5); $5 += 0}
    $5 >= ALERT {printf "%s is almost full: %d%%\n", $1, $5}
')

memorymessage=""
musage=$(free | awk '/Mem/{printf("RAM Usage: %.2f%\n"), $3/$2*100}' |  awk '{print $3}' | cut -d"." -f1)
if [ $musage -ge $ALERT ]; then
   memorymessage="Current Memory Usage: $musage%\n"
fi

message="$diskmessage$memorymessage"

if [ -n "$message" ]; then
  echo "$message"
  htmlMessage="${message//$'\n'/<br />}"
  echo "$htmlMessage" | ./bin/sendgrid.sh clark@countable.ca "Disk usage is high on $HOSTNAME."
fi 
