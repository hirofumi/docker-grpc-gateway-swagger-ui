FROM golang:1.14.3-alpine AS builder

RUN apk add git npm protobuf-dev protoc

COPY swagger-ui-server /go/src/github.com/hirofumi/docker-grpc-gateway-swagger-ui/swagger-ui-server

RUN cd /go/src/github.com/hirofumi/docker-grpc-gateway-swagger-ui/swagger-ui-server \
    && go install \
        github.com/golang/protobuf/protoc-gen-go \
        github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
        github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    && go generate ./... \
    && go build -ldflags '-w -s' -o /go/bin/swagger-ui-server . \
    && cd "$(find /go/pkg/mod/github.com/grpc-ecosystem -name 'grpc-gateway@*' | sort -r -t@ -V | head -n 1)" \
    && mkdir /grpc-gateway \
    && find . -name '*.proto' -exec cp --parents {} /grpc-gateway ';'

FROM alpine:3.11

ENV PROTO_DIRECTORY /proto
ENV PROTO_FILES *.proto
ENV SWAGGER_DIRECTORY /api
ENV SWAGGER_FILE apidocs.swagger.json
ENV SWAGGER_PARAMS logtostderr=true,json_names_for_fields=true,allow_merge=true

ENV SHUTDOWN_TIMEOUT=10s
ENV PORT 3000

COPY --from=builder /go/bin /usr/local/bin
COPY --from=builder /grpc-gateway /grpc-gateway

RUN mkdir "$SWAGGER_DIRECTORY" && apk --no-cache add protobuf-dev protoc

EXPOSE $PORT

CMD ["sh", "-c", "cd \"$PROTO_DIRECTORY\" && protoc -I/grpc-gateway -I/grpc-gateway/third_party/googleapis -I. --swagger_out=\"$SWAGGER_PARAMS:$SWAGGER_DIRECTORY\" $PROTO_FILES && swagger-ui-server"]
