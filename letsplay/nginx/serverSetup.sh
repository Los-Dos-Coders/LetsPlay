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
  # Create Cron File
  mkdir -p ~/crontabs
  touch ~/crontabs/jobs.txt

  # Cron Jobs
  printf "8 0 * * * /bin/sh /ssl/renewCertificate.sh\n" >>  ~/crontabs/jobs.txt
  printf "0 * * * * /bin/sh curl -fsS --retry 5 --data-raw \"Server up and Running\" https://hc-ping.com/f6dc8b14-ff24-4c7e-8a3b-c9ed4d8a9f86\n" >>  ~/crontabs/jobs.txt

  # Submit Cron Jobs to crontab
  crontab ~/crontabs/jobs.txt
}

installPreRequisites
if [ "$ENV" = "prod" ]; then
  installCertbot
  addCronJobs
else
  installMkcert
fi