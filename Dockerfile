FROM golang:alpine as builder

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

WORKDIR /go/src/github.com/seidu626/abk-user-service

COPY . .

RUN go get
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .


FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app
COPY --from=builder /go/src/github.com/seidu626/abk-user-service .

CMD ["./shippy-user-service"]
