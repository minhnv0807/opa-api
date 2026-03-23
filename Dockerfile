FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

ARG VERSION=dev
ARG COMMIT=none
ARG BUILD_DATE=unknown

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -X 'main.Version=${VERSION}' -X 'main.Commit=${COMMIT}' -X 'main.BuildDate=${BUILD_DATE}'" -o ./opa-api ./cmd/server/

FROM alpine:3.22.0

LABEL maintainer="OPA AI Labs <hello@opa.vn>"
LABEL description="OPA API - Universal AI CLI Proxy Server"
LABEL org.opencontainers.image.source="https://github.com/opa-ai-labs/opa-api"

RUN apk add --no-cache tzdata

RUN mkdir /opa-api

COPY --from=builder ./app/opa-api /opa-api/opa-api

COPY config.example.yaml /opa-api/config.example.yaml

WORKDIR /opa-api

EXPOSE 8317

ENV TZ=Asia/Ho_Chi_Minh

RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone

CMD ["./opa-api"]