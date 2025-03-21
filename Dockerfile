FROM oven/bun:latest as builder

WORKDIR /app

COPY . .

RUN bun install

# Detect architecture and set appropriate target
RUN bun run build

FROM alpine:latest as runner

WORKDIR /app

COPY --from=builder /app/sena-lichtlabs-org .

EXPOSE 3000

CMD ["./sena-lichtlabs-org"]
