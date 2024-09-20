FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && chown -R appuser:appgroup /app
EXPOSE 3000
USER appuser
CMD ["npm", "start"]
