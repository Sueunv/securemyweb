# Build Stage
FROM node:18 AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the code and build the app
COPY . .
RUN npm run build

# Production Stage
FROM nginx:alpine

# Copy custom nginx config if you have one
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port and start nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

