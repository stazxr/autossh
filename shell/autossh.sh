#!/bin/bash

createSsh() {
  ip=$1
  user=$2
  password=$3

  echo "Create $user's ssh from local to $ip..."
  su $user -c "expect $autosshFile $user@$ip $password" >> $logFile
  if [ $? != 0 ]; then
    echo "Create $user's ssh from local to $ip...failed"
    return 1
  fi

  echo "Create $user's ssh from local to $ip...done"
}

main() {
  if [ ! -f $hostCfgFile ]; then
    echo "autossh.cfg not exist"
    exit 1
  fi

  cat $hostCfgFile | grep -v '^[ ]*#' | while read hostInfo
  do
    ip=`echo $hostInfo | awk '{print $1}'`
    user=`echo $hostInfo | awk '{print $2}'`
    password=`echo $hostInfo | awk '{print $3}'`

    if [ -z $ip -o -z $user -o -z $password ]; then
      continue
    fi

    createSsh $ip $user $password
  done
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

hostCfgFile=$SCRIPT_DIR/autossh.cfg
autosshFile=$SCRIPT_DIR/createTrustSsh.exp
logFile=$SCRIPT_DIR/ssh.log

main
