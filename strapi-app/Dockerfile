# Use official Node.js LTS as base
FROM node:20

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy all source files
COPY . .

# Build Strapi (optional if you have admin panel)
RUN npm run build

# Expose Strapi default port
EXPOSE 1337

# Run Strapi in production
CMD ["npm", "start"]
