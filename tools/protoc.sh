#/bin/sh

set -eu

GRPC_GATEWAY="$(find $(go env GOPATH)/pkg/mod/github.com/grpc-ecosystem/ -name 'grpc-gateway@*' | sort -r -t@ -V | head -n 1)"

protoc -I"$GRPC_GATEWAY" -I"$GRPC_GATEWAY/third_party/googleapis" "$@"
