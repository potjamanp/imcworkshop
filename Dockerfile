FROM nginx:alpine
LABEL org.opencontainers.image.source https://github.com/potjamanp/imcworkshop
COPY ./html /usr/share/nginx/html