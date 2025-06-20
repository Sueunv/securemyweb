# ===== Build Stage =====
FROM node:18 AS build

WORKDIR /app

# Copy only package files first to install deps (including react-scripts)
COPY package.json package-lock.json ./

RUN npm install

# Now copy everything else (like src/, public/, etc.)
COPY . .

RUN npm run build

# ===== Production Stage =====
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

