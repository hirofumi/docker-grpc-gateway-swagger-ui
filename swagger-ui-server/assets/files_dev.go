//+build dev

package assets

import "net/http"

var Files http.FileSystem = http.Dir("node_modules/swagger-ui-dist")
