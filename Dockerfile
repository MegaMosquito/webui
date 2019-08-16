FROM node:8.16.0

WORKDIR /webui
COPY public/* /webui/public/
COPY src/* /webui/src/
COPY package.json /webui

CMD npm install && npm start
