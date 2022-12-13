#!/bin/sh

set -e

# Creating Env Variables moved to separate step to avoid leaking tokens
export DNS_DIGITALOCEAN_TOKEN=${DNS_DIGITALOCEAN_TOKEN}
export CERTBOT_EMAIL=${CERTBOT_EMAIL}
export DOMAIN=${DOMAIN}
export ENV=${ENV}