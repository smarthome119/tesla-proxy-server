FROM golang:1.23-alpine AS builder
RUN apk add --no-cache git openssl
RUN git clone https://github.com/teslamotors/vehicle-command.git /src
WORKDIR /src
RUN go build -o /tesla-http-proxy ./cmd/tesla-http-proxy
FROM alpine:3.19
RUN apk add --no-cache openssl ca-certificates socat
