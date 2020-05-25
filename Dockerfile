FROM golang:1.14.3-alpine

ENV PATH $PATH:/go/bin
ENV TOOLS /go/src/github.com/hirofumi/docker-grpc-gateway-swagger-ui/tools

COPY tools $TOOLS

RUN mkdir /api \
    && apk --no-cache --virtual .deps add git \
    && apk --no-cache add nodejs npm protobuf-dev protoc \
    && cd "$TOOLS/deps" \
    && go install \
        github.com/golang/protobuf/protoc-gen-go \
        github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
        github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    && cd "$TOOLS/ui" \
    && npm i \ 
    && rm -rf "$TOOLS/deps" \
    && apk del .deps

ENV PROTO_FILE /proto/*.proto
ENV SWAGGER_JSON apidocs.swagger.json
ENV SWAGGER_OUT logtostderr=true,json_names_for_fields=true,allow_merge=true:/api
ENV PORT 3000

EXPOSE $PORT

WORKDIR $TOOLS
CMD ["sh", "-c", "./protoc.sh -I/proto --swagger_out=$SWAGGER_OUT $PROTO_FILE && cd ui && npm start"]
