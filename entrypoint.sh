#exit on any error
set -e

#access to docker?
socket=/var/run/docker.sock
if [ ! -e $socket ]; then
  echo "$socket does not exist, have you mounted it?"
  echo "  docker run"
  echo "    -v /var/run/docker.sock:/var/run/docker.sock"
  echo "  docker-compose.yml"
  echo "    volumes:"
  echo "      - /var/run/docker.sock:/var/run/docker.sock"
  exit 1
fi

#update timezone and sanity print date before starting crontab.
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
cp /crontab /etc/crontabs/root
chown root:root /etc/crontabs/root
echo -n "crontab timezone: $TZ | "
date

#usage tips if crontab is unmodified.
if cmp -s /crontab.example /etc/crontabs/root; then
  echo "Volume mount /crontab with entries like:"
  echo "   * * * * * docker exec $HOSTNAME echo Hello"
  echo "See /crontab.example."
fi

#run crontab in foreground
/usr/sbin/crond -f