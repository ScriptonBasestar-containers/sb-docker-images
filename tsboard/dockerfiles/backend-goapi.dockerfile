# 1단계: 빌드 환경
FROM golang:1.23-alpine AS build

# 작업 디렉토리 설정
WORKDIR /app

# Go 모듈 초기화 및 종속성 설치
COPY repos/goapi/go.mod .
COPY repos/goapi/go.sum .
RUN go mod download

# 소스 코드 복사
COPY repos/goapi .

# GOAPI 빌드
RUN go build -o tsboard-goapi ./cmd/main.go

# 2단계: 배포 환경
FROM alpine:latest

# 타임존 설정 (예: 서울)
ENV TZ=Asia/Seoul
RUN apk add --no-cache tzdata

# 실행 파일 복사
COPY --from=build /app/tsboard-goapi /usr/local/bin/tsboard-goapi

# 실행 권한 부여
RUN chmod +x /usr/local/bin/tsboard-goapi

# 환경 변수 설정 (필요에 따라 수정)
ENV PORT=3100
ENV DATABASE_URL="user:password@tcp(db:3306)/tsboard"

# 포트 노출
EXPOSE 3100

# 애플리케이션 실행
CMD ["tsboard-goapi"]
