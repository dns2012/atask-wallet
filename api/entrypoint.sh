#!/bin/bash
set -e

# Remove any existing server.pid file
if [ -f tmp/pids/server.pid ]; then
  echo "Removing stale server.pid file..."
  rm -f tmp/pids/server.pid
fi

# Execute the container's main process (Rails server)
exec "$@"
