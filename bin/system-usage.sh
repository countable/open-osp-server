#!/bin/bash

ALERT=90

message=$(df -h | awk -v ALERT="$ALERT" '
    NR == 1 {next}
    $1 == "abc:/xyz/pqr" {next}
    $1 == "tmpfs" {next}
    $1 == "overlay" {next}
    $1 == "/dev/cdrom" {next}
    1 {sub(/%/,"",$5)}
    $5 >= ALERT {printf "%s is almost full: %d%%\n", $1, $5}
')
if [ -n "$message" ]; then
  echo "$message"
  htmlMessage="${message//$'\n'/<br />}"
  echo "$htmlMessage" | ./bin/sendgrid.sh clark@countable.ca "Disk usage is high on $HOSTNAME."
fi 
