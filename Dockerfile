# Step 1: Use a lightweight Node.js image for the build stage
FROM node:18-alpine as build-stage
WORKDIR /app

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install all dependencies (including dev dependencies)
RUN npm install

# Copy the rest of the application source code
COPY . .

# Step 2: Run Angular's production build
RUN ng build --configuration production

# Step 3: Use an Nginx image to serve the Angular app (this keeps the final image small)
FROM nginx:alpine as production-stage

# Copy the built app from the build-stage
COPY --from=build-stage /app/dist/ng-beginner /usr/share/nginx/html

# Expose port 80 for Nginx (not 4200)
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]
