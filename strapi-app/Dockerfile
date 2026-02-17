FROM node:20

WORKDIR /app

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

# Build Strapi admin panel
RUN yarn build

EXPOSE 1337

CMD ["yarn", "start"]
