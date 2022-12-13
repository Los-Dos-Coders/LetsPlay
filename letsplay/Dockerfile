FROM node:alpine as build

WORKDIR /app
COPY . /app/

RUN npm clean-install
RUN npm run build

FROM certbot/dns-digitalocean:latest as certificates

ARG DNS_DIGITALOCEAN_TOKEN
ARG CERTBOT_EMAIL
ARG DOMAIN

WORKDIR /ssl
COPY --from=build /app/nginx ./nginx

RUN export DNS_DIGITALOCEAN_TOKEN=${DNS_DIGITALOCEAN_TOKEN}
RUN export CERTBOT_EMAIL=${CERTBOT_EMAIL}
RUN export DOMAIN=${DOMAIN}

RUN chmod +x ./nginx/GetCertificates.sh
RUN ./nginx/GetCertificates.sh
RUN ls -a

FROM nginx:stable-alpine as start
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=certificates /ssl/ /ssl
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]