FROM node:alpine as build

WORKDIR /app
COPY . /app/

RUN npm clean-install
RUN npm run build

# FROM certbot/dns-digitalocean:latest
FROM nginx:stable

ARG DNS_DIGITALOCEAN_TOKEN
ARG CERTBOT_EMAIL
ARG DOMAIN
ARG ENV

WORKDIR /ssl
COPY --from=build /app/nginx ./

RUN chmod +x ./GetCertificates.sh
RUN chmod +x ./serverSetup.sh

RUN ./serverSetup.sh
RUN ./GetCertificates.sh

COPY --from=build /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
CMD ["/bin/sh", "-c", "cron && nginx -g \"daemon off;\""]