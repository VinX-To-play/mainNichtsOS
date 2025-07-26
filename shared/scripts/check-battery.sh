#!/usr/bin/env bash

notify_levels=(3 5 10 15)
BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)
declare -A notified

for lvl in "${notify_levels[@]}"; do
    notified[$lvl]=0
done

while true; do
    bat_lvl=$(cat "/sys/class/power_supply/${BAT}/capacity")

    for notify_level in "${notify_levels[@]}"; do
        if [ "$bat_lvl" -le "$notify_level" ] && [ "${notified[$notify_level]}" -eq 0 ]; then
            notify-send -u critical "Low Battery" "$bat_lvl% battery remaining."
            notified[$notify_level]=1
        elif [ "$bat_lvl" -gt "$notify_level" ]; then
            # Reset notification if battery goes above threshold again
            notified[$notify_level]=0
        fi
    done

    sleep 60
done

