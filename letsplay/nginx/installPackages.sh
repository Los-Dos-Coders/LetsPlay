#!/bin/sh

set -e

apk add py3-pip
pip3 install certbot
pip3 install certbot-dns-digitalocean


apk add nss

# Install mkcert
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert
chmod +x /usr/local/bin/mkcert