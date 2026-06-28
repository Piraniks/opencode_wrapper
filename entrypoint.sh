#!/bin/sh

dockerd >/var/log/dockerd.log 2>&1 &
i=0
until docker info >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -ge 50 ]; then
    echo "warning: dockerd not ready after 50 * 0.3s, continuing anyway (see /var/log/dockerd.log)" >&2
    break
  fi
  sleep 0.3
done
exec "$@"