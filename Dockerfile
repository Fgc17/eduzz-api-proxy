
##### STAGE I

# Base image
FROM node:18-alpine AS build

# Create app directory
WORKDIR /app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# build js & remove devDependencies from node_modules
RUN npm install

COPY . .

RUN npm run build

##### STAGE II

FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/dist /app/dist
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/package.json /app/package.json
RUN rm -rf /app/dist/migrations/*.d.ts /app/dist/migrations/*.map

# Start the server using the production build
CMD [ "node", "dist/main", "--max-old-space-size=256" ]


