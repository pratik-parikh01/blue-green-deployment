FROM node:18.17-alpine3.18

COPY Run.sh /app/Run.sh
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
COPY index.js /app/index.js
RUN cd /app && npm ci
