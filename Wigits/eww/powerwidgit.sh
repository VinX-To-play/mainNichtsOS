#!/usr/bin/env bash

close="${1:-false}"
monitors=$(xrandr --listmonitors | grep -E "[0-9]" -m 1 -o)

if [ $close = "false" ]
then
  for (( i=1; i<=$monitors; i++ )); do
  eww open clickcatch --screen $(($i - 1)) --id $i
  done
  sleep 0.1
  for (( i=1; i<=$monitors; i++ )); do
  eww open powerwindow --screen $(($i - 1)) --id $(($i * 5))
  done
elif [ $close = "true" ]
then
  for (( i=1; i<=$monitors; i++ )); do
  eww close $i
  eww close $(($i * 5))
  done
else
  echo "wrong argument"
fi


