# Use an appropriate Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /create-react-app

# Copy package.json and package-lock.json
COPY public/ /create-react-app/public
COPY src/ /create-react-app/src
COPY package.json /create-react-app/

# Install  dependencies 
RUN npm install 
# Copy application source code
COPY . .

# Expose port if necessary
# EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
