# build stage
FROM golang:1.11.5 AS build-env
RUN go get -d -v github.com/labstack/echo && \
    go get -d -v github.com/labstack/echo/middleware && \
    go get -d -v github.com/mattn/go-sqlite3
ADD . /src
ADD ./public/ /src
RUN cd /src && go build -o gopoll

# final stage
FROM alpine
# credit to: https://github.com/olivere/sqlite-docker
RUN apk --update upgrade && \
    apk add sqlite && \
    rm -rf /var/cache/apk/*
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
WORKDIR /app
COPY --from=build-env /src /app/
COPY --from=build-env /src/public/ /app/
ENTRYPOINT ./gopoll