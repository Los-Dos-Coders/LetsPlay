FROM node:alpine

WORKDIR /app
COPY . /app/
RUN npm clean-install
EXPOSE 8000
CMD ["npm", "start"]