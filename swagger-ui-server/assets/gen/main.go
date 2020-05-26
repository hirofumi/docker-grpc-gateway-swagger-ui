//+build ignore

package main

import (
	"log"

	"github.com/hirofumi/docker-grpc-gateway-swagger-ui/swagger-ui-server/assets"
	"github.com/shurcooL/vfsgen"
)

func main() {
	err := vfsgen.Generate(assets.Files, vfsgen.Options{
		PackageName:  "assets",
		BuildTags:    "!dev",
		VariableName: "Files",
	})
	if err != nil {
		log.Fatalln(err)
	}
}
