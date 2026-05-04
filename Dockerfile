# ---- build stage ----
FROM node:22-slim AS build

RUN npm install -g bun@1.3.11

WORKDIR /app

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

COPY src/ src/
COPY scripts/ scripts/
COPY bin/ bin/
COPY tsconfig.json ./

RUN bun run build

RUN rm -rf node_modules && bun install --frozen-lockfile --production

# ---- runtime stage ----
FROM node:22-slim

WORKDIR /app

COPY --from=build /app/dist/cli.mjs dist/cli.mjs
COPY --from=build /app/bin/ bin/
COPY --from=build /app/node_modules/ node_modules/
COPY --from=build /app/package.json package.json

USER root

# Core runtime tools + requested dev utilities.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      git \
      ripgrep \
      golang-go \
      python3 \
      python3-pip \
      make \
      jq \
    && rm -rf /var/lib/apt/lists/*

USER node

ENTRYPOINT ["node", "/app/dist/cli.mjs"]
