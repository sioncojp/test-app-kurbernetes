APP        ?= test-app-kurbernetes
COMMIT     ?=  $(shell git rev-parse --short HEAD)
BUILD_TIME ?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')
GOOS       ?= linux
GOARCH     ?= amd64
PORT       ?= 8000

REGION     ?= asia-northeast1-a

clean:
	rm -f $(APP)

install:
	gcloud components install kubectl docker-credential-gcr

build: clean
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build \
		-ldflags "-s -w -X version.Commit=$(COMMIT) \
		-X version.BuildTime=$(BUILD_TIME)" \
		-o $(APP)

container: _required_id build
	docker build -t $(APP):latest .
	docker tag asia.gcr.io/$(ID)/$(APP):latest $(APP):latest

run:
	docker run --name $(APP) -p $(PORT):$(PORT) --rm \
		-e "PORT=$(PORT)" \
		$(APP):latest

_required_id:
ifeq ($(ID),)
	$(error "you should define projectID..... $$ make ID=xxxxxxx")
endif

_required_cred:
ifeq ($(CRED),)
	$(error "you should define credential json..... $$ make CRED=xxxx.json")
endif

login: _required_cred
	docker-credential-gcr configure-docker
	@docker login -u _json_key -p '$(shell cat $(CRED))' https://gcr.io

push: login _required_id container
	gcloud docker -- push asia.gcr.io/$(ID)/$(APP):latest

start: cluster/create cluster/auth cluster/deployment
stop: cluster/delete

cluster/create:
	-gcloud container clusters create $(APP) \
	  --zone $(REGION) \
	  --num-nodes 2 \
	  --machine-type g1-small

cluster/auth:
	-gcloud container clusters get-credentials $(APP) --zone $(REGION)
	gcloud container clusters list

cluster/deployment: _required_id
	-kubectl run $(APP) --image asia.gcr.io/$(ID)/$(APP) --port $(PORT)
	-kubectl expose deployment $(APP) --type "LoadBalancer"
	kubectl get service $(APP)

cluster/delete: _required_id
	-kubectl delete service $(APP)
	-gcloud container clusters delete $(APP)

.PHONY: clean build container run push start stop cluster/*
