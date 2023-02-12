FROM golang:1.16-alpine

WORKDIR /

COPY go.mod ./

RUN go mod download

RUN apk update && apk add curl

COPY *.go ./

RUN go build -o /client
