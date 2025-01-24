#!/bin/bash

podman exec -u root -it web certbot certonly --standalone --expand \
    -d digitalkingdom.org -d davidleepowell.com -d teddyb.org \
    -d www.digitalkingdom.org -d www.davidleepowell.com -d www.teddyb.org \
    -d robinleepowell.name -d rlpowell.name \
    -d gdoc-to-ao3.digitalkingdom.org \
    -d waffles.digitalkingdom.org \
    -d users.digitalkingdom.org \
    -d mail.digitalkingdom.org -d stodi.digitalkingdom.org \
    -d mail.teddyb.org -d stodi.teddyb.org \
    -d mail.evolutionlab.org -d stodi.evolutionlab.org \
    --non-interactive --agree-tos --email robinleepowell@gmail.com --http-01-port=8888
podman exec -u root -it web chown -R $(id -u):$(id -g) /etc/letsencrypt/

cat containers/web/data/letsencrypt/live/digitalkingdom.org/fullchain.pem containers/web/data/letsencrypt/live/digitalkingdom.org/privkey.pem > containers/web/data/letsencrypt/live/digitalkingdom.org/haproxy.pem

systemctl --user restart web

# .realm certs
CAROOT="$HOME/dk-haproxy/misc/realm_certs/ca_root/" TRUST_STORES='none' mkcert -install
# Don't try to do a *.realm wildcard; it seems to not work in chrome
CAROOT="$HOME/dk-haproxy/misc/realm_certs//ca_root/" TRUST_STORES='none' mkcert -cert-file misc/realm_certs/star.realm.pem -key-file misc/realm_certs/star.realm.key -p12-file misc/realm_certs/star.realm.p12 hassio.realm waffles.realm plex.realm vaultwarden.realm pihole.realm pi-hole.realm hassio.r3alm waffles.r3alm plex.r3alm vaultwarden.r3alm pihole.r3alm pi-hole.r3alm 192.168.123.127
