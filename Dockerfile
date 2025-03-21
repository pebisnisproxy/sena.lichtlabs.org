FROM oven/bun:alpine AS base
WORKDIR /usr/src/app

FROM base AS install
RUN mkdir -p /temp/prod
COPY package.json bun.lock /temp/prod/
RUN cd /temp/prod && bun install --frozen-lockfile --production

FROM base AS prerelease
COPY --from=install /temp/prod/node_modules node_modules
COPY . .
ENV NODE_ENV=production
RUN bun run build

FROM alpine:latest AS release
COPY --from=prerelease /usr/src/app/pgp .
COPY --from=prerelease /usr/src/app/index.html .
COPY --from=prerelease /usr/src/app/favicon.ico .
COPY --from=prerelease /usr/src/app/sena-lichtlabs-org .
RUN apk add --no-cache libgcc libstdc++
RUN chmod +x sena-lichtlabs-org
EXPOSE 3000/tcp
ENTRYPOINT [ "./sena-lichtlabs-org" ]
