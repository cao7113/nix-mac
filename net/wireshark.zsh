# wireshark

wlogon(){
  export SSLKEYLOGFILE=~/.tlskey.log
  echo SSLKEYLOGFILE=$SSLKEYLOGFILE
}
wlogoff(){
  unset SSLKEYLOGFILE
  echo SSLKEYLOGFILE=$SSLKEYLOGFILE
}