APP        ?= test-app-kurbernetes
COMMIT     ?=  $(shell git rev-parse --short HEAD)
BUILD_TIME ?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')
GOOS       ?= linux
GOARCH     ?= amd64
PORT       ?= 8000

clean:
	rm -f $(APP)

build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build \
		-ldflags "-s -w -X version.Commit=${COMMIT} \
		-X version.BuildTime=${BUILD_TIME}" \
		-o ${APP}

container: build
	docker build -t $(APP):latest .

run: container
	docker run --name ${APP} -p ${PORT}:${PORT} --rm \
		-e "PORT=${PORT}" \
		$(APP):latest
