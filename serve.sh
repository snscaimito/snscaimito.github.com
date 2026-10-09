#!/bin/sh

set -eu

HOST="${JEKYLL_HOST:-127.0.0.1}"
START_PORT="${JEKYLL_PORT_START:-4000}"
END_PORT="${JEKYLL_PORT_END:-4100}"
LIVERELOAD_START_PORT="${JEKYLL_LIVERELOAD_PORT_START:-35729}"
LIVERELOAD_END_PORT="${JEKYLL_LIVERELOAD_PORT_END:-35829}"

find_free_port() {
  ruby -rsocket -e '
    host, first, last = ARGV
    (Integer(first)..Integer(last)).each do |port|
      begin
        server = TCPServer.new(host, port)
        server.close
        puts port
        exit 0
      rescue Errno::EADDRINUSE, Errno::EACCES
        next
      end
    end
    exit 1
  ' "$HOST" "$1" "$2"
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

# Restore story illustrations only for this local unpublished preview.
# Derive the config so every other production exclusion stays in effect.
PREVIEW_CONFIG_DIR="$(mktemp -d "${TMPDIR:-/tmp}/jekyll-preview.XXXXXX")"
PREVIEW_CONFIG="$PREVIEW_CONFIG_DIR/_config.yml"
ruby -ryaml -e '
  config = YAML.load_file("_config.yml")
  config["exclude"] = Array(config["exclude"]).reject { |path| path.start_with?("img/") }
  File.write(ARGV.fetch(0), config.to_yaml)
' "$PREVIEW_CONFIG"

echo "Starting Jekyll on http://$HOST:$PORT/"
echo "LiveReload port: $LIVERELOAD_PORT"

exec bundle exec jekyll serve \
  --config "$PREVIEW_CONFIG" \
  --host "$HOST" \
  --port "$PORT" \
  --baseurl "$LOCAL_BASEURL" \
  --future \
  --unpublished \
  --livereload \
  --livereload-port "$LIVERELOAD_PORT" \
  "$@"
