#!/bin/sh

set -u

while true; do
  protoc \
    -I/grpc-gateway \
    -I/grpc-gateway/third_party/googleapis \
    -I. \
    --swagger_out="$SWAGGER_PARAMS:$SWAGGER_DIRECTORY" \
    "$@"
  inotifywait -q -e create -e modify -e move -r .
done &

set -e

swagger-ui-server
