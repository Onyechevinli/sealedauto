# Use official Node.js runtime as base image (Debian slim to reduce known Alpine package vulnerabilities)
FROM node:22-bullseye-slim

# Update OS packages to pick up security fixes
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Set working directory in container
WORKDIR /app

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Install dependencies first (for better caching)
COPY package*.json ./
RUN npm ci --only=production

# Copy application source code
COPY . .

# Create non-root user for security
RUN addgroup --gid 1001 --system nodejs
RUN adduser --system nextjs --uid 1001

# Change ownership of the app directory to the non-root user
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose the application port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Start the application
CMD ["node", "server.js"]