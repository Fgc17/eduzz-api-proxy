#### STAGE I

# Use a node:18 image as the base image
FROM node:18-alpine AS build

# Install PNPM globally
RUN npm install -g pnpm

# Create app directory
WORKDIR /app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package.json pnpm-lock.yaml ./

# Install project dependencies using PNPM
RUN pnpm install

COPY . .

# Build your project (modify this line if your build script is different)
RUN pnpm run build

##### STAGE II

# Use a node:18 image as the base image
FROM node:18-alpine

# Install PNPM globally
RUN npm install -g pnpm

WORKDIR /app

# Copy project files from Stage I
COPY --from=build /app/dist /app/dist
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/package.json /app/package.json
RUN rm -rf /app/dist/migrations/*.d.ts /app/dist/migrations/*.map

# Start the server using the production build
CMD [ "node", "dist/main", "--max-old-space-size=256" ]


