# Use latest Node.js version as the base image
FROM node:latest AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build TypeScript code
RUN npm run build

# Start a new stage with a minimal Node.js image
FROM node:slim

# Set the working directory in the container
WORKDIR /app

# Copy only necessary files from the previous stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist/

# Install only production dependencies
RUN npm install --only=production

# Expose the port your app runs on
EXPOSE 3000

# Command to run your application
CMD ["npm", "run", "start"]
