#!/usr/bin/env bash

ERRORS='';
while true; do
  make --silent all 2> _errors.log 1> _output.log
  NEW_ERRORS=`cat _errors.log`
  if [ "$NEW_ERRORS" != "" ]; then
    cp _errors.log errors.log
    ERRORS=$NEW_ERRORS
    echo $ERRORS
    if [ "$ERRORS" = "" ]; then
      echo "Compilation Successful"
    fi
  fi
  sleep 1
done
