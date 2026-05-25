#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"
RUN_DIR="$ROOT_DIR/.run"

BACKEND_PORT="${BACKEND_PORT:-8087}"
FRONTEND_PORT="${FRONTEND_PORT:-3007}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-1234}"

JAVA_17_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"

mkdir -p "$RUN_DIR"

log() {
  printf '[start] %s\n' "$1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

port_pids() {
  local port="$1"
  if command_exists lsof; then
    lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true
  fi
}

wait_for_http() {
  local name="$1"
  local url="$2"
  local timeout="${3:-30}"
  local elapsed=0

  while [ "$elapsed" -lt "$timeout" ]; do
    if curl -s -o /dev/null "$url"; then
      log "$name is ready: $url"
      return 0
    fi
    sleep 1
    elapsed=$((elapsed + 1))
  done

  log "$name did not respond within ${timeout}s. Check logs under $RUN_DIR"
  return 1
}

setup_java() {
  if [ -z "${JAVA_HOME:-}" ] && [ -d "$JAVA_17_HOME" ]; then
    export JAVA_HOME="$JAVA_17_HOME"
  fi

  if [ -n "${JAVA_HOME:-}" ]; then
    export PATH="$JAVA_HOME/bin:$PATH"
  fi

  export PATH="/opt/homebrew/bin:$PATH"

  if ! command_exists java; then
    log "java was not found. Install Java 17 first."
    exit 1
  fi

  if ! command_exists mvn; then
    log "mvn was not found. Install Maven first."
    exit 1
  fi
}

start_mysql() {
  if command_exists brew && brew list --versions mysql >/dev/null 2>&1; then
    log "starting MySQL service"
    brew services start mysql >/dev/null || true
  fi

  if command_exists mysqladmin; then
    if mysqladmin ping -h localhost -uroot -p"$MYSQL_PASSWORD" >/dev/null 2>&1; then
      log "MySQL is ready"
      return 0
    fi
  fi

  log "MySQL is not confirmed ready. Backend may fail if localhost:3306 is unavailable."
}

start_backend() {
  local pid_file="$RUN_DIR/backend.pid"
  local log_file="$RUN_DIR/backend.log"

  if [ -n "$(port_pids "$BACKEND_PORT")" ]; then
    log "backend port $BACKEND_PORT is already in use; skip starting backend"
    return 0
  fi

  log "starting backend on port $BACKEND_PORT"
  (
    cd "$BACKEND_DIR"
    nohup mvn spring-boot:run >"$log_file" 2>&1 &
    printf '%s\n' "$!" >"$pid_file"
  )

  wait_for_http "backend" "http://127.0.0.1:$BACKEND_PORT/api/auth/login" 45
}

start_frontend() {
  local pid_file="$RUN_DIR/frontend.pid"
  local log_file="$RUN_DIR/frontend.log"

  if [ -n "$(port_pids "$FRONTEND_PORT")" ]; then
    log "frontend port $FRONTEND_PORT is already in use; skip starting frontend"
    return 0
  fi

  if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
    log "frontend dependencies missing; running npm install"
    (
      cd "$FRONTEND_DIR"
      npm install
    )
  fi

  log "starting frontend on port $FRONTEND_PORT"
  (
    cd "$FRONTEND_DIR"
    nohup npm run dev -- --host 127.0.0.1 >"$log_file" 2>&1 &
    printf '%s\n' "$!" >"$pid_file"
  )

  wait_for_http "frontend" "http://127.0.0.1:$FRONTEND_PORT/" 30
}

setup_java
start_mysql
start_backend
start_frontend

log "done"
log "frontend: http://127.0.0.1:$FRONTEND_PORT/"
log "backend:  http://127.0.0.1:$BACKEND_PORT/"
log "logs:     $RUN_DIR"
