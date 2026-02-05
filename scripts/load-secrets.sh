#!/bin/sh
# load-secrets.sh - Load /run/secrets/* files as environment variables
# Each file's name becomes the env var name, contents become the value.
# Existing env vars are NOT overridden (Docker -e flags take priority).
# Used as ENTRYPOINT wrapper in Dockerfile.botenv.

SECRETS_DIR="/run/secrets"

if [ -d "$SECRETS_DIR" ]; then
  for file in "$SECRETS_DIR"/*; do
    [ -f "$file" ] || continue
    name="$(basename "$file")"
    # Skip if already set in environment
    if [ -z "$(eval echo "\${${name}+x}")" ]; then
      value="$(cat "$file")"
      export "${name}=${value}"
    fi
  done
fi

exec "$@"
