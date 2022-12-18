#!/bin/sh

set -e

requestFromCertbot() {

  # Get Credentials
  touch /ssl/certbot-creds.ini
  chmod go-rwx /ssl/certbot-creds.ini
  echo dns_digitalocean_token = "$DNS_DIGITALOCEAN_TOKEN" >> /ssl/certbot-creds.ini

  # Generate Certificate
  certbot certonly --dns-digitalocean --dns-digitalocean-credentials /ssl/certbot-creds.ini --email "$CERTBOT_EMAIL" -d "$DOMAIN" --agree-tos --non-interactive --test-cert
}

requestSelfSigned() {

  # Create Certificate Authority and Install Certificate
  mkcert -install
  mkcert localhost

  # Move and Rename Generated Certificates
  mkdir -p /etc/letsencrypt/live/letsplaytech.com
  mv ./localhost.pem /etc/letsencrypt/live/letsplaytech.com/fullchain.pem
  mv ./localhost-key.pem /etc/letsencrypt/live/letsplaytech.com/privkey.pem
}

getRecommendedConfig() {
  # Download Official LetsEncrypt Nginx Config
  wget https://github.com/certbot/certbot/blob/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf?raw=true -O /ssl/options-ssl-nginx.conf
  openssl dhparam -out /ssl/dhparam.pem 4096
}

# Main
getRecommendedConfig
if [ "$ENV" = "prod" ]; then
  echo "Environment: Production => Requesting Production SSL via Certbot..."
  requestFromCertbot
else 
  echo "Environment: Development => Requesting Self-Signed SSL..."
  requestSelfSigned
fi