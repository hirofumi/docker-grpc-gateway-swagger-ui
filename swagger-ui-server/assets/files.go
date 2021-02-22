package assets

import (
	"embed"
	"io/fs"
)

//go:generate npm i
//go:embed node_modules/swagger-ui-dist
var root embed.FS

const prefix = "node_modules/swagger-ui-dist"

var Files fs.FS

func init() {
	var err error

	Files, err = fs.Sub(root, prefix)

	if err != nil {
		panic(err)
	}
}
