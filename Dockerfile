# Stage 1: Build the React app
FROM node:18-alpine AS build_step

WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./
# Add .npmrc if you created one, or use the flag below
COPY .npmrc ./ 

# Install dependencies (using the legacy flag we discussed)
RUN npm ci --legacy-peer-deps

# Copy the rest of the code and build
COPY . .
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:1.23-alpine

# Copy the build output from the first stage to Nginx
COPY --from=build_step /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]