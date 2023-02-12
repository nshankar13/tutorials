#!make

IMAGE_NAME ?= palindrome-app
IMAGE_TAG ?= latest
IMAGE_REGISTRY ?= nshankar13

test:
	go test -v

docker-build:
	docker build -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .
