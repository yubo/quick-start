#!/bin/bash
OUTPUT_PATH=${OUTPUT_PATH:-.}

#go env -w GOPROXY=goproxy.cn,direct
GO111MODULE=on go install go.opentelemetry.io/collector/cmd/builder@latest

builder --config=./otelcol-builder.yaml --output-path=./.build --name otelcol-custom && \
mv ./.build/otelcol-custom ${OUTPUT_PATH}
cp /usr/local/go/lib/time/zoneinfo.zip ${OUTPUT_PATH}/zoneinfo.zip
