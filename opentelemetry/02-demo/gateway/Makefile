.PHONY: clean
IMAGE_NAME=opentelemetry-collector-custom

all: image

otelcol-custom: otelcol-builder.yaml
	docker run --rm --name otelcol-builder \
		-e OUTPUT_PATH=/src \
		-e GOMODCACHE=/src/.cache \
		-e GOOS=linux \
		-w /src \
		-v ${PWD}:/src \
		golang:1.17 \
		./build.sh

image: otelcol-custom
	docker build -f ./Dockerfile -t $(IMAGE_NAME) .

clean:
	rm -f otelcol-custom
	docker rmi $(IMAGE_NAME)
