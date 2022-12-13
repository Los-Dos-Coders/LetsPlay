#!/bin/sh

set -e

requestFromCertbot() {
  touch ~/certbot-creds.ini
  chmod go-rwx ~/certbot-creds.ini
  echo dns_digitalocean_token = "$DNS_DIGITALOCEAN_TOKEN" >> ~/certbot-creds.ini
  certbot certonly --dns-digitalocean --dns-digitalocean-credentials ~/certbot-creds.ini --email "$CERTBOT_EMAIL" -d "$DOMAIN" --test-cert --agree-tos --non-interactive
  cp /etc/letsencrypt/live/$DOMAIN/* /ssl
}

requestSelfSigned() {
  echo "TODO: GENERATE SELF-SIGNED CERT AND SAVE IN /ssl"
  echo "Files Needed: fullchain.pem and privkey.pem"

  # Install NSS
  apk add nss

  # Install mkcert
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
  cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert
  chmod +x /usr/local/bin/mkcert

  # Create Certificate Authority and Install Certificate
  mkcert -install
  mkcert localhost

  # Move and Rename Generated Certificates
  mv ./localhost.pem /ssl/fullchain.pem
  mv ./localhost-key.pem /ssl/privkey.pem
}

getRecommendedConfig() {
  wget https://github.com/certbot/certbot/blob/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf?raw=true -O /ssl/options-ssl-nginx.conf
}

# requestFromCertbot
requestSelfSigned
getRecommendedConfig