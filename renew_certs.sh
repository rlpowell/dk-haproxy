#!/bin/bash

# This is often called from cron, so:
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH

podman exec -u root -it web certbot renew --tls-sni-01-port=8888
podman exec -u root -it web chown -R $(id -un):$(id -gn) /etc/letsencrypt/

cat /home/spdkhaproxy/dk-haproxy/containers/web/data/letsencrypt/live/digitalkingdom.org/fullchain.pem \
    /home/spdkhaproxy/dk-haproxy/containers/web/data/letsencrypt/live/digitalkingdom.org/privkey.pem > \
    /home/spdkhaproxy/dk-haproxy/containers/web/data/letsencrypt/live/digitalkingdom.org/haproxy.pem

systemctl --user restart web
