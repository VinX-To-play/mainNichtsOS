#!/usr/bin/env bash

close="${1:-false}"

if [ $close = "false" ]
then
  eww open clickcatch 
  sleep 0.1
  eww open powerwindow
elif [ $close = "true" ]
then
  eww close clickcatch &
  eww close powerwindow
else
  echo "wrong argument"
fi


