#!/bin/bash
# SYSTEM RESOURCE MONITOR - Linux Version

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

draw_bar() {
    local percent=$1
    local width=30
    local filled=$(echo "$percent * $width / 100" | bc 2>/dev/null || echo "0")
    local bar=""
    for ((i=1; i<=filled; i++)); do bar="${bar}█"; done
    for ((i=filled+1; i<=width; i++)); do bar="${bar}░"; done
    echo "$bar"
}

clear
echo -e "${CYAN}==================================================${NC}"
echo -e "${CYAN}      SYSTEM RESOURCE MONITOR (LINUX)${NC}"
echo -e "${CYAN}==================================================${NC}"
echo -e "${GRAY}Press Ctrl+C to exit${NC}"
echo ""

while true; do
    current_time=$(date +%H:%M:%S)
    
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    cpu_bar=$(draw_bar $cpu)
    
    ram_total=$(free -h | awk 'NR==2{print $2}')
    ram_used=$(free -h | awk 'NR==2{print $3}')
    ram_percent=$(free | awk 'NR==2{printf "%.1f", $3*100/$2}')
    ram_bar=$(draw_bar $ram_percent)
    
    disk_total=$(df -h / | awk 'NR==2{print $2}')
    disk_free=$(df -h / | awk 'NR==2{print $4}')
    disk_percent=$(df / | awk 'NR==2{print $5}' | sed 's/%//')
    disk_bar=$(draw_bar $disk_percent)
    
    processes=$(ps aux --sort=-%cpu | head -6 | tail -5)
    
    printf "\033[6;0H"
    
    echo -e "${GRAY}Last Update: $current_time${NC}"
    echo ""
    echo -e "${GREEN} CPU:  $cpu_bar  ${cpu}%${NC}"
    echo -e "${GREEN} RAM:  $ram_bar  ${ram_percent}%  (${ram_used} / ${ram_total})${NC}"
    echo -e "${GREEN} DISK: $disk_bar  ${disk_percent}%  (Free: ${disk_free} / ${disk_total})${NC}"
    echo ""
    echo -e "${YELLOW}--------------------------------------------------${NC}"
    echo -e "${YELLOW} TOP 5 PROCESSES (by CPU usage)${NC}"
    echo -e "${YELLOW}--------------------------------------------------${NC}"
    
    count=1
    echo "$processes" | while read line; do
        proc_name=$(echo "$line" | awk '{print $11}' | xargs basename)
        cpu_usage=$(echo "$line" | awk '{print $3}')
        printf " ${WHITE}%d. %-25s - %s%% CPU${NC}\n" "$count" "$proc_name" "$cpu_usage"
        ((count++))
    done
    
    echo ""
    echo -e "${GRAY}--------------------------------------------------${NC}"
    echo -e "${GRAY} Press Ctrl+C to exit${NC}"
    
    sleep 2
done