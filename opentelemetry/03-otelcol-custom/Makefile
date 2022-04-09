.PHONY: clean

all: otelcol-custom

otelcol-custom: otelcol-builder.yaml
	docker run --rm --name otelcol-builder \
		-e OUTPUT_PATH=/src \
		-e GOMODCACHE=/go/pkg/mod \
		-e GOOS=linux \
		-w /src \
		-v ${PWD}:/src \
		-v ${GOPATH}/pkg/mod:/go/pkg/mod \
		golang:1.17 \
		./build.sh

clean:
	rm -f otelcol-custom
