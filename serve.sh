#!/bin/sh

set -eu

HOST="${JEKYLL_HOST:-127.0.0.1}"
START_PORT="${JEKYLL_PORT_START:-4000}"
END_PORT="${JEKYLL_PORT_END:-4100}"
LIVERELOAD_START_PORT="${JEKYLL_LIVERELOAD_PORT_START:-35729}"
LIVERELOAD_END_PORT="${JEKYLL_LIVERELOAD_PORT_END:-35829}"

find_free_port() {
  port="$1"
  end_port="$2"

  while [ "$port" -le "$end_port" ]; do
    if ! lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
      printf '%s\n' "$port"
      return 0
    fi

    port=$((port + 1))
  done

  return 1
}

if ! command -v bundle >/dev/null 2>&1; then
  echo "bundle is required but not installed." >&2
  exit 1
fi

PORT="$(find_free_port "$START_PORT" "$END_PORT")" || {
  echo "No free port found between $START_PORT and $END_PORT." >&2
  exit 1
}

LIVERELOAD_PORT="$(find_free_port "$LIVERELOAD_START_PORT" "$LIVERELOAD_END_PORT")" || {
  echo "No free LiveReload port found between $LIVERELOAD_START_PORT and $LIVERELOAD_END_PORT." >&2
  exit 1
}

LOCAL_BASEURL="${JEKYLL_LOCAL_BASEURL:-}"

echo "Starting Jekyll on http://$HOST:$PORT/"

exec bundle exec jekyll serve \
  --host "$HOST" \
  --port "$PORT" \
  --baseurl "$LOCAL_BASEURL" \
  --future \
  --livereload \
  --livereload-port "$LIVERELOAD_PORT" \
  "$@"