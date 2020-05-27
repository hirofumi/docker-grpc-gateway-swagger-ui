# docker-grpc-gateway-swagger-ui

## Usage

```
$ git clone --depth=1 -b v1.14.6 https://github.com/grpc-ecosystem/grpc-gateway.git 
$ PROTO_DIR=$PWD/grpc-gateway/examples/internal/helloworld
$ docker run -p 3000:3000 -v"$PROTO_DIR:/proto:ro" --rm -it hiro/grpc-gateway-swagger-ui
```

```
$ open http://localhost:3000
```
