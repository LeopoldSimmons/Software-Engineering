#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_DIR="$ROOT_DIR/.run"

BACKEND_PORT="${BACKEND_PORT:-8087}"
FRONTEND_PORT="${FRONTEND_PORT:-3007}"
STOP_MYSQL="${STOP_MYSQL:-0}"
STOP_BY_PORT="${STOP_BY_PORT:-1}"

log() {
  printf '[stop] %s\n' "$1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

is_running() {
  local pid="$1"
  kill -0 "$pid" >/dev/null 2>&1
}

stop_pid_file() {
  local name="$1"
  local pid_file="$2"

  if [ ! -f "$pid_file" ]; then
    log "$name pid file not found"
    return 0
  fi

  local pid
  pid="$(cat "$pid_file")"

  if [ -z "$pid" ] || ! is_running "$pid"; then
    log "$name is not running"
    rm -f "$pid_file"
    return 0
  fi

  log "stopping $name pid $pid"
  kill "$pid" >/dev/null 2>&1 || true

  local elapsed=0
  while is_running "$pid" && [ "$elapsed" -lt 10 ]; do
    sleep 1
    elapsed=$((elapsed + 1))
  done

  if is_running "$pid"; then
    log "$name did not stop cleanly; forcing pid $pid"
    kill -9 "$pid" >/dev/null 2>&1 || true
  fi

  rm -f "$pid_file"
}

stop_port() {
  local name="$1"
  local port="$2"

  if [ "$STOP_BY_PORT" != "1" ] || ! command_exists lsof; then
    return 0
  fi

  local pids
  pids="$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)"
  if [ -z "$pids" ]; then
    return 0
  fi

  log "stopping $name listener(s) on port $port: $pids"
  for pid in $pids; do
    kill "$pid" >/dev/null 2>&1 || true
  done
}

stop_pid_file "frontend" "$RUN_DIR/frontend.pid"
stop_pid_file "backend" "$RUN_DIR/backend.pid"

stop_port "frontend" "$FRONTEND_PORT"
stop_port "backend" "$BACKEND_PORT"

if [ "$STOP_MYSQL" = "1" ]; then
  if command_exists brew && brew list --versions mysql >/dev/null 2>&1; then
    log "stopping MySQL service"
    brew services stop mysql >/dev/null || true
  else
    log "MySQL Homebrew service not found"
  fi
else
  log "MySQL left running. Use STOP_MYSQL=1 ./stop.sh to stop it too."
fi

log "done"
