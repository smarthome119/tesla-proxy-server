FROM golang:1.23-alpine AS builder
RUN apk add --no-cache git openssl
RUN git clone https://github.com/teslamotors/vehicle-command.git /src
WORKDIR /src
RUN go build -o /tesla-http-proxy ./cmd/tesla-http-proxy

FROM alpine:3.19
# 줄바꿈 문자 처리를 위해 sed가 포함된 기본 패키지들과 함께 필요한 도구 설치
RUN apk add --no-cache openssl ca-certificates socat sed

# 빌드된 바이너리를 시스템 실행 경로로 복사
COPY --from=builder /tesla-http-proxy /usr/bin/tesla-http-proxy

WORKDIR /app
COPY start.sh .

# ⭐️ [핵심] start.sh 파일에 낀 윈도우 줄바꿈 찌꺼기(\r)를 강제로 제거하고 실행 권한 부여
RUN sed -i 's/\r$//' start.sh && chmod +x start.sh

# 안전하게 쉘을 통해 스크립트 실행
CMD ["/bin/sh", "start.sh"]
