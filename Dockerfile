FROM node:lts-alpine

WORKDIR /anca/src/app-fe

COPY package*.json ./

RUN npm install -g http-server

COPY . .

RUN npm install

RUN npm run build

EXPOSE 8091
CMD [ "http-server", "dist" ]



# FROM node:lts-alpine as build-stage
# WORKDIR /anca/src/app-fe
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# # production stage
# FROM nginx:stable-alpine as production-stage
# COPY --from=build-stage /anca/src/app-fe/dist /usr/share/nginx/html
# EXPOSE 8091
# CMD ["nginx", "-g", "daemon off;"]