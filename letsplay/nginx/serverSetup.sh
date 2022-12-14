#!/bin/sh

set -e

installPreRequisites() {
  apt-get update && apt-get install -y cron wget
}

installCertbot() {
  apt-get install -y python3-pip
  pip3 install certbot
  pip3 install certbot-dns-digitalocean
}

installMkcert() {
  apt-get install -y libnss3-tools
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
  cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert
  chmod +x /usr/local/bin/mkcert
  rm -rf ./mkcert-v1.4.3-linux-amd64
}

addCronJobs() {
  mkdir -p ~/crontabs
  touch ~/crontabs/jobs.txt

  # TODO: Add actual cron job and healthcheck
  # echo "0 0 * * * certbot renew --post-hook \"nginx -s reload\" --test-cert && curl -m https://hc-ping.com/138fff81-9936-4bc8-9d72-6286bf2059ee" >>  ~/crontabs/jobs.txt
  
  crontab ~/crontabs/jobs.txt
}

installPreRequisites
if [ "$ENV" = "prod" ]; then
  installCertbot
else
  installMkcert
fi
addCronJobs