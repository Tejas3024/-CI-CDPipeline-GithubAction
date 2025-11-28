# Stage 1: Builder
FROM node:20-alpine AS builder

WORKDIR /app

# Create dist folder
RUN mkdir -p /app/dist

# Copy package files first (better for caching)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy application files
COPY . .

# Build the project (if build script exists)
RUN npm run build --if-present


# Stage 2: Production image
FROM node:20-alpine AS prod

WORKDIR /app

# Copy build output from builder stage
COPY --from=builder /app/dist ./dist

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Start the app
CMD ["node", "dist/index.js"]
