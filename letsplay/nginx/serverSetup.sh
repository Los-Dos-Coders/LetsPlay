#!/bin/sh

set -e

installCertbot() {
  apk add py3-pip
  pip3 install certbot
  pip3 install certbot-dns-digitalocean
}

installMkcert() {
  apk add nss
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
  cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert
  chmod +x /usr/local/bin/mkcert
  rm -rf ./mkcert-v1.4.3-linux-amd64
}

addCronJobs() {
  mkdir -p ~/crontabs
  touch ~/crontabs/jobs.txt
  echo "0       0       *       *       *       certbot renew --post-hook \"nginx -s reload\" --test-cert && curl -m https://hc-ping.com/138fff81-9936-4bc8-9d72-6286bf2059ee" >>  ~/crontabs/jobs.txt
  echo "*/5     *       *       *       *        curl -m https://hc-ping.com/69b44581-f586-450f-b28b-2df87192a25f" >>  ~/crontabs/jobs.txt
  crontab ~/crontabs/jobs.txt
}

installCertbot
installMkcert
addCronJobs