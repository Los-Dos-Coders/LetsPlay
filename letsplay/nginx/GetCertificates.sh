#!/bin/sh

set -e

requestFromCertbot() {
  touch ~/certbot-creds.ini
  chmod go-rwx ~/certbot-creds.ini
  echo dns_digitalocean_token = "$DNS_DIGITALOCEAN_TOKEN" >> ~/certbot-creds.ini
  certbot certonly --dns-digitalocean --dns-digitalocean-credentials ~/certbot-creds.ini --email "$CERTBOT_EMAIL" -d "$DOMAIN" --test-cert --agree-tos --non-interactive
  cp /etc/letsencrypt/live/$DOMAIN/* /ssl
  wget https://github.com/certbot/certbot/blob/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf?raw=true -O /ssl/options-ssl-nginx.conf
}

requestSelfSigned() {
  echo "TODO: GENERATE SELF-SIGNED CERT AND SAVE IN /ssl"
  echo "Files Needed: fullchain.pem and privkey.pem"
}

requestFromCertbot