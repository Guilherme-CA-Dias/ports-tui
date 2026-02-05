#!/usr/bin/env bash

REFRESH=60
FILTER_REGEX="node|docker|containerd|uvicorn|gunicorn|python|postgres|redis"

get_ports() {
  ss -tulpnH | while read -r proto state recv send local peer proc; do
    [[ "$proto" != "tcp" && "$proto" != "udp" ]] && continue

    port="${local##*:}"
    pid="$(echo "$proc" | grep -o 'pid=[0-9]*' | cut -d= -f2)"
    pname="$(echo "$proc" | grep -o '\"[^\"]*\"' | tr -d '"')"

    [[ -z "$pid" || -z "$pname" ]] && continue
    [[ ! "$pname" =~ $FILTER_REGEX ]] && continue

    addr="${local%:*}"

    printf "%-4s │ %-15s │ %-5s │ %-6s │ %s\n" \
      "$proto" "$addr" "$port" "$pid" "$pname"
  done
}

draw() {
  clear
  echo " DEV PORTS WATCHER  (auto-refresh: ${REFRESH}s, r = refresh, q = quit)"
  echo " ─────────────────────────────────────────────────────────────"
  echo " PROT │ ADDRESS         │ PORT  │ PID    │ PROCESS"
  echo " ─────┼─────────────────┼───────┼────────┼────────────"

  rows="$(get_ports | sort -k5 -n)"

  if [[ -z "$rows" ]]; then
    echo " (no matching dev services listening)"
  else
    echo "$rows"
  fi
}

draw
last_refresh=$(date +%s)

while true; do
  now=$(date +%s)
  elapsed=$((now - last_refresh))

  if (( elapsed >= REFRESH )); then
    draw
    last_refresh=$now
  fi

  read -rsn1 -t 1 key
  case "$key" in
    q)
      exit 0
      ;;
    r)
      draw
      last_refresh=$(date +%s)
      ;;
    "")
      selection=$(get_ports | sort -k5 -n | \
        fzf --header="Select a process (ENTER = kill, ESC = cancel)" \
            --border \
            --layout=reverse)

      [[ -z "$selection" ]] && continue

      pid=$(echo "$selection" | awk '{print $7}')
      port=$(echo "$selection" | awk '{print $5}')

      clear
      echo "Selected:"
      echo "$selection"
      echo
      read -rp "Kill process on port $port (PID $pid)? [y/N] " confirm

      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        kill -9 "$pid" && echo "✔ Killed PID $pid"
        sleep 1
      fi

      draw
      last_refresh=$(date +%s)
      ;;
  esac
done
