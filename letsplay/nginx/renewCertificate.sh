#!/bin/sh

m=$(/usr/local/bin/certbot renew --post-hook "nginx -s reload" --test-cert 2>&1)
curl -fsS --retry 5 --data-raw "$m" https://hc-ping.com/0e697fb4-177c-4ff5-a30c-e3af404d4fbe/$?