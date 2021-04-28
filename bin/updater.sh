#!/bin/bash

cd $WORKSPACE
folders=$(ls -d * | grep -v kumo)

COMMAND=$1
WORKSPACE={$4:-/home/jenkins/workspace}

case "${COMMAND}" in
    update)

./bin/openosp-setup.sh $2 $3
echo updating $folders

for environment in $folders
do
   echo $environment	
   cd $WORKSPACE
   cd $environment
   echo ''
   echo '************************************'
   echo 'Upating' $environment
   git status
   pull
   openosp update
   sleep 60
   openosp health
   if [[ $? == 0 ]]; then
       echo "SUCCESS!"
   else
       echo "FAILED :("

       ./../bin/sendgrid.sh clark@countable.ca "Update failed for $environment"
   fi
done;;
    check)

for environment in $folders
do
    curl -I https://$environment.openosp.ca/oscar/index.jsp

   if [[ $? == 0 ]]; then
       echo "SUCCESS!"
   else
       echo "FAILED :("

       ./../bin/sendgrid.sh clark@countable.ca "Check failed for $environment"
   fi
done;;

    backup)

for environment in $folders
do
    cd $WORKSPACE
    cd $environment
    echo ''
    echo '********************'
    echo 'Starting Backups' $environment
    openosp backup -m --s3

    if [[ $? == 0 ]]; then
       echo "SUCCESS!"
    else
       echo "FAILED :("

       ./../sendgrid.sh clark@countable.ca "Backups failed for $environment"
    fi
done;;

	usage)

#!/bin/bash

ALERT=80

message=$(df -h | awk -v ALERT="$ALERT" '
    NR == 1 {next}
    $1 == "abc:/xyz/pqr" {next}
    $1 == "tmpfs" {next}
    $1 == "/dev/cdrom" {next}
    1 {sub(/%/,"",$5)}
    $5 >= ALERT {printf "%s is almost full: %d%%\n", $1, $5}
')
if [ -n "$message" ]; then
  echo "$message"
  htmlMessage="${message//$'\n'/<br />}"
  echo "$htmlMessage" | ./sendgrid.sh clark@countable.ca "Disk usage is high on $HOSTNAME."
fi 


esac
