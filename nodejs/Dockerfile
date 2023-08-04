FROM node:20-alpine

RUN apk update && apk upgrade

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install

COPY . .

EXPOSE 8888

CMD ["npm", "start"]
