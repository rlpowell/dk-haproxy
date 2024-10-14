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
