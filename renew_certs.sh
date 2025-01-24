#!/bin/bash

# Error trapping from https://gist.github.com/oldratlee/902ad9a398affca37bfcfab64612e7d1
__error_trapper() {
  local parent_lineno="$1"
  local code="$2"
  local commands="$3"
  echo "error exit status $code, at file $0 on or near line $parent_lineno: $commands"
}
trap '__error_trapper "${LINENO}/${BASH_LINENO}" "$?" "$BASH_COMMAND"' ERR

set -euE -o pipefail
shopt -s failglob

# This is often called from cron, so:
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH

podman exec -u root -it web certbot renew --http-01-port 8888
podman exec -u root -it web chown -R $(id -u):$(id -g) /etc/letsencrypt/

cat /home/spdkhaproxy/dk-haproxy/containers/web/data/letsencrypt/live/digitalkingdom.org/fullchain.pem \
    /home/spdkhaproxy/dk-haproxy/containers/web/data/letsencrypt/live/digitalkingdom.org/privkey.pem > \
    /home/spdkhaproxy/dk-haproxy/containers/web/data/letsencrypt/live/digitalkingdom.org/haproxy.pem

# .realm certs
# Don't try to do a *.realm wildcard; it seems to not work in chrome
CAROOT="/home/spdkhaproxy/dk-haproxy/misc/realm_certs/ca_root/" TRUST_STORES='none' mkcert -cert-file '/home/spdkhaproxy/dk-haproxy/misc/realm_certs/star.realm.pem' -key-file '/home/spdkhaproxy/dk-haproxy/misc/realm_certs/star.realm.key' -p12-file misc/realm_certs/star.realm.p12 hassio.realm waffles.realm plex.realm vaultwarden.realm pihole.realm pi-hole.realm hassio.r3alm waffles.r3alm plex.r3alm vaultwarden.r3alm pihole.r3alm pi-hole.r3alm 192.168.123.127

systemctl --user restart web

echo "cert renewal complete"
