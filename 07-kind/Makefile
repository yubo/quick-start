.PHONY: install up clean

name=dev
image=kindest/node:v1.27.3

up:
	KUBECONFIG=~/.kube/kind-dev.yaml && \
	kind create cluster --name $(name) --image $(image) --config ./kind-config.yaml --retain -v 1
	#kind create cluster --name $(name) --image $(image) 

clean:
	KUBECONFIG=~/.kube/kind-dev.yaml && \
	kind delete cluster --name $(name)

deploy:
	KUBECONFIG=~/.kube/kind-dev.yaml && \
	kubectl apply -f ./deploy.yaml

install:
	go install sigs.k8s.io/kind@v0.19.0
