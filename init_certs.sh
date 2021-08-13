#!/bin/bash

podman exec -u root -it web certbot certonly --standalone --expand \
    -d digitalkingdom.org -d davidleepowell.com -d teddyb.org \
    -d www.digitalkingdom.org -d www.davidleepowell.com -d www.teddyb.org \
    -d robinleepowell.name -d rlpowell.name \
    -d gdoc-to-ao3.digitalkingdom.org \
    --non-interactive --agree-tos --email robinleepowell@gmail.com --http-01-port=8888
podman exec -u root -it web chown -R $(id -un):$(id -gn) /etc/letsencrypt/

cat containers/web/data/letsencrypt/live/digitalkingdom.org/fullchain.pem containers/web/data/letsencrypt/live/digitalkingdom.org/privkey.pem > containers/web/data/letsencrypt/live/digitalkingdom.org/haproxy.pem

systemctl --user restart web
