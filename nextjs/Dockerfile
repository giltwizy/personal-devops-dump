# Build Stage
FROM node:20-alpine AS BUILD_IMAGE
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production Stage
FROM node:20-alpine AS PRODUCTION_STAGE
RUN apk update && apk upgrade
RUN npm install -g npm@9.8.1
RUN npx next telemetry disable
WORKDIR /app
COPY --from=BUILD_IMAGE /app/package*.json ./
COPY --from=BUILD_IMAGE /app/.next ./.next
COPY --from=BUILD_IMAGE /app/public ./public
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules
ENV NODE_ENV=production
EXPOSE 8090
CMD ["npm", "start"]
