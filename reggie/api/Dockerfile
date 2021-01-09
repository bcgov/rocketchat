FROM node:12.16-alpine

RUN mkdir /opt/app
WORKDIR /opt/app

COPY build/ .
RUN npm ci --silent

EXPOSE 8000 9229

CMD [ "npm", "start" ]
