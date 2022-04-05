FROM node:15.0.0 as builder

RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app

COPY package*.json ./
USER node
RUN yarn install

COPY --chown=node:node . .
RUN yarn build

EXPOSE 8085

FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /home/node/app/build/ /usr/share/nginx/html