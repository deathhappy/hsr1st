FROM    node:lts-alpine as builder
WORKDIR /app
COPY    package*.json  ./
COPY    vite.config.js ./
COPY    index.html     ./
COPY    nginx.conf     ./
ADD     src            ./src
RUN     npm install -g npm@10.5.2
RUN     npm install
RUN     npm run format
RUN     npm run build

FROM nginx:1.24.0
COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/nginx.conf /etc/nginx/
