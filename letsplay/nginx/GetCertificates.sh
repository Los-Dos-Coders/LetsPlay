#!/bin/sh

set -e

requestFromCertbot() {
  
  # TODO: MODIFY CERTBOT -> INSTALL ONTO NGINX CONTAINER
  # TODO: SETUP AUTORENEW USING CRONTAB

  ## SAMPLE SCRIPT TO RENEW
  # # add crontab entry to renew the letsencrypt certificate
  # echo "adding crontab"
  # echo "0 23 * * * certbot renew --dry-run" | crontab -

  # # start nginx
  # echo "starting nginx"
  # nginx

  ## END SAMPLE SCRIPT

  # Get Credentials
  touch ~/certbot-creds.ini
  chmod go-rwx ~/certbot-creds.ini
  echo dns_digitalocean_token = "$DNS_DIGITALOCEAN_TOKEN" >> ~/certbot-creds.ini

  # Generate Certificate
  certbot certonly --dns-digitalocean --dns-digitalocean-credentials ~/certbot-creds.ini --email "$CERTBOT_EMAIL" -d "$DOMAIN" --test-cert --agree-tos --non-interactive

  # Save Certificates
  cp /etc/letsencrypt/live/$DOMAIN/* /ssl
}

requestSelfSigned() {

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