package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	"github.com/hirofumi/docker-grpc-gateway-swagger-ui/swagger-ui-server/assets"
)

func main() {
	var err error

	port, err := strconv.Atoi(os.Getenv("PORT"))
	if err != nil {
		log.Fatalf("invalid PORT: %s\n", err)
	}

	shutdownTimeout, err := time.ParseDuration(os.Getenv("SHUTDOWN_TIMEOUT"))
	if err != nil {
		log.Fatalf("invalid SHUTDOWN_TIMEOUT: %s\n", err)
	}

	swaggerDirectory := os.Getenv("SWAGGER_DIRECTORY")
	entryPoint := fmt.Sprintf("/?url=%s/%s", swaggerDirectory, os.Getenv("SWAGGER_FILE"))

	uiServer := http.FileServer(http.FS(assets.Files))
	jsonServer := http.StripPrefix(swaggerDirectory, http.FileServer(http.Dir(swaggerDirectory)))

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case strings.HasPrefix(r.URL.Path, swaggerDirectory):
			jsonServer.ServeHTTP(w, r)
		case r.URL.Path == "/":
			if len(r.URL.Query()) == 0 {
				http.Redirect(w, r, entryPoint, http.StatusTemporaryRedirect)
			}
			fallthrough
		case strings.HasPrefix(r.URL.Path, "/"):
			uiServer.ServeHTTP(w, r)
		}
	})

	srv := &http.Server{
		Addr:    net.JoinHostPort("", strconv.Itoa(port)),
		Handler: handler,
	}

	go func() {
		if err := srv.ListenAndServe(); !errors.Is(err, http.ErrServerClosed) {
			log.Fatalln(err)
		}
	}()

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, os.Interrupt, syscall.SIGTERM)

	<-sig

	ctx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalln(err)
	}
}
