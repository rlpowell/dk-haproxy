#!/bin/bash

podman exec -u root -it web certbot renew --tls-sni-01-port=8888
podman exec -u root -it web chown -R $(id -un):$(id -gn) /etc/letsencrypt/

cat containers/web/data/letsencrypt/live/digitalkingdom.org/fullchain.pem containers/web/data/letsencrypt/live/digitalkingdom.org/privkey.pem > containers/web/data/letsencrypt/live/digitalkingdom.org/haproxy.pem

systemctl --user restart web
