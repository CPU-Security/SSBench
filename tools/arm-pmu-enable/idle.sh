#!/bin/bash

# 获取当前 online 的 CPU 编号（例如：0-3,5,7）
cpu_list=$(cat /sys/devices/system/cpu/online)

# 将范围转换成实际数字列表
cpu_array=()
IFS=',' read -ra entries <<< "$cpu_list"
for entry in "${entries[@]}"; do
    if [[ "$entry" == *-* ]]; then
        IFS='-' read -ra range <<< "$entry"
        for ((i=${range[0]}; i<=${range[1]}; i++)); do
            cpu_array+=("$i")
        done
    else
        cpu_array+=("$entry")
    fi
done

# 禁用每个 CPU 的 C-state 0 和 1
for cpu in "${cpu_array[@]}"; do
    for state in 0 1; do
        path="/sys/devices/system/cpu/cpu$cpu/cpuidle/state$state/disable"
        if [[ -w "$path" ]]; then
            echo 1 > "$path"
        fi
    done
done