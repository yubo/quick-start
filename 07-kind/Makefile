.PHONY: install up clean

name=dev
image=kindest/node:v1.30.0

install:
	go install sigs.k8s.io/kind@v0.23.0

up:
	kind create cluster --name $(name) --image $(image) --config ./kind-config.yaml --retain -v 1

clean:
	kind delete cluster --name $(name)
