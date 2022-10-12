FROM node:12.11.1 AS builder
WORKDIR /app
COPY . ./
RUN npm install
RUN npm rebuild node-sass
ARG ENVIRONMENT='development'
COPY .env.${ENVIRONMENT} .env
RUN npm run build

# For the production environment COPY to Nginx webserver document root
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]