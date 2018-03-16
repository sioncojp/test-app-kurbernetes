package main

import (
	"log"
	"net/http"
	"os"
)

func main() {
	logger := log.New(os.Stdout, "http: ", log.LstdFlags)
	logger.Println("Server is starting...")

	router := http.NewServeMux()
	router.Handle("/", http.HandlerFunc(index))
	router.Handle("/healthcheck", http.HandlerFunc(healthcheck))

	server := &http.Server{
		Addr:    ":8000",
		Handler: router,
	}

	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		logger.Fatalf("Could not listen on 8000 : %v\n", err)
	}
}

func index(w http.ResponseWriter, req *http.Request) {
	w.Write([]byte("Hello world"))
}

func healthcheck(w http.ResponseWriter, req *http.Request) {
	w.WriteHeader(http.StatusOK)
}
