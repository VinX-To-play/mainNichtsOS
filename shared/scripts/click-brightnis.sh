#!/usr/bin/env bash

brightness=$(brightnessctl i | grep -oP '\(([^()]*)%' | sed 's/(//g' | sed 's/%//g')

if [ $brightness -ge 20 ]; then
    brightnessctl s 1
else
    brightnessctl s 100%
fi
