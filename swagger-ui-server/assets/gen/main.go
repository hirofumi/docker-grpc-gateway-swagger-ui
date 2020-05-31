//+build ignore

package main

import (
	"log"
	"os"
	"strings"

	"github.com/hirofumi/docker-grpc-gateway-swagger-ui/swagger-ui-server/assets"
	"github.com/shurcooL/httpfs/filter"
	"github.com/shurcooL/vfsgen"
)

func main() {
	err := vfsgen.Generate(filter.Skip(assets.Files, skip), vfsgen.Options{
		PackageName:  "assets",
		BuildTags:    "!dev",
		VariableName: "Files",
	})
	if err != nil {
		log.Fatalln(err)
	}
}

func skip(path string, _ os.FileInfo) bool {
	return strings.HasSuffix(path, "/package.json") ||
		strings.HasSuffix(path, "/README.md") ||
		strings.HasSuffix(path, ".map")
}
