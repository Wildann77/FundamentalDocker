# --- Stage 1: Base ---
FROM node:20-alpine AS base

# Install dependencies needed for some node modules
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Copy package files
COPY package*.json ./

# --- Stage 2: Development ---
FROM base AS development
# Install all dependencies including devDependencies
RUN npm install
# Copy source code
COPY . .
# Set environment
ENV NODE_ENV=development
EXPOSE 3000
CMD ["npm", "run", "dev"]

# --- Stage 3: Production Build ---
FROM base AS build
# Install only production dependencies
RUN npm ci --only=production
# Copy source code
COPY . .

# --- Stage 4: Production Run ---
FROM node:20-alpine AS production
WORKDIR /app

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -u 1001 -S nodejs -G nodejs

# Copy only necessary files from build stage
COPY --from=build --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=build --chown=nodejs:nodejs /app/package.json ./package.json
COPY --from=build --chown=nodejs:nodejs /app/index.js ./index.js
# Copy other folders if they exist (routes, models, etc)
COPY --from=build --chown=nodejs:nodejs /app/routes ./routes
COPY --from=build --chown=nodejs:nodejs /app/models ./models
COPY --from=build --chown=nodejs:nodejs /app/config ./config

USER nodejs

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "index.js"]
