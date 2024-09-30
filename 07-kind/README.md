# kind

## 指定kube.config

用环境变量
```
KUBECONFIG=~/.kube/kind-dev.yaml
```

修改配置
```
kubectl config use-context kind-dev
```

## install kubectl

```
curl -LO https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl

```



- https://kind.sigs.k8s.io/docs/user/quick-start/
