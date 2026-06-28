#!/bin/sh

USER_ID=${UID:-1000}
GROUP_ID=${GID:-1000}

dockerd --group "$GROUP_ID" >/var/log/dockerd.log 2>&1 &
i=0
until docker info >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -ge 50 ]; then
    echo "warning: dockerd not ready after 50 * 0.3s, continuing anyway (see /var/log/dockerd.log)" >&2
    break
  fi
  sleep 0.3
done

if [ "$(id -u)" = "0" ]; then
  export HOME="/workdir"
  exec setpriv --reuid="$USER_ID" --regid="$GROUP_ID" --clear-groups "$@"
fi

exec "$@"