FROM golang:alpine as builder

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh gcc musl-dev

WORKDIR /go/src/github.com/seidu626/abk-user-service

COPY . .

RUN go get
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .
#RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-w' -i -o micro .

FROM alpine:latest

RUN apk add --update ca-certificates && \
    rm -rf /var/cache/apk/* /tmp/*

RUN mkdir /app
WORKDIR /app
COPY --from=builder /go/src/github.com/seidu626/abk-user-service .
CMD ["./abk-user-service"]
#ENTRYPOINT [ "./micro" ]
