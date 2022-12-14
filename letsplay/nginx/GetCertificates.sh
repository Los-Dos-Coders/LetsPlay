#!/bin/sh

set -e

requestFromCertbot() {
  
  # TODO: SETUP AUTORENEW USING CRONTAB

  # Get Credentials
  touch /ssl/certbot-creds.ini
  chmod go-rwx /ssl/certbot-creds.ini
  echo dns_digitalocean_token = "$DNS_DIGITALOCEAN_TOKEN" >> /ssl/certbot-creds.ini

  # Generate Certificate
  certbot certonly --dns-digitalocean --dns-digitalocean-credentials /ssl/certbot-creds.ini --email "$CERTBOT_EMAIL" -d "$DOMAIN" --test-cert --agree-tos --non-interactive
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
  wget https://github.com/certbot/certbot/blob/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf?raw=true -O /ssl/options-ssl-nginx.conf
}


# Main
getRecommendedConfig
if [ "$ENV" == "prod" ]; then
  echo "Environment: Production => Requesting Production SSL via Certbot..."
  sleep 10
  requestFromCertbot
else 
  echo "Environment: Development => Requesting Self-Signed SSL..."
  sleep 10
  requestSelfSigned
fi