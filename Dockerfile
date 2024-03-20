FROM node:lts AS node_build
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx:1.16.0
COPY --from=node_build /app/build /usr/share/nginx/html