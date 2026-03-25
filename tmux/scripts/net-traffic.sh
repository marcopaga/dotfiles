#!/usr/bin/env bash
# net-traffic.sh — show network up/down speed for the default interface
# Usage: net-traffic.sh
# Output example: up 1.2M dn 3.4K

IFACE=$(route get default 2>/dev/null | awk '/interface:/{print $2}')
[ -z "$IFACE" ] && echo "no net" && exit 0

get_bytes() {
  netstat -ib | awk -v iface="$IFACE" '
    $1 == iface && $3 !~ /Link/ { print $7, $10; exit }
  '
}

read -r rx1 tx1 <<< "$(get_bytes)"
sleep 1
read -r rx2 tx2 <<< "$(get_bytes)"

fmt() {
  local b=$1
  if   [ "$b" -ge 1048576 ]; then printf "%.1fM" "$(echo "scale=1; $b/1048576" | bc)"
  elif [ "$b" -ge 1024 ];    then printf "%.0fK" "$(echo "scale=0; $b/1024"    | bc)"
  else                             printf "%dB"  "$b"
  fi
}

up=$(( tx2 - tx1 ))
dn=$(( rx2 - rx1 ))
[ "$up" -lt 0 ] && up=0
[ "$dn" -lt 0 ] && dn=0

echo "up $(fmt $up) dn $(fmt $dn)"
