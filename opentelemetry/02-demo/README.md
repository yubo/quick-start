# open-telemetry

#### install es

如果使用已有 es， 跳过这一步，配置 [otel-collector-config.yaml](./otel-collector-config.yaml)  文件中的 exporters.elasticsearch/customname 部分

- [Install ElasticSearch](../../elasticsearch/)

创建 index, 默认的密码为 elastic:admin1234

```
curl -X GET -u elastic:admin1234 'http://localhost:9200/test'
```

#### 配置 otel-collector-config.yaml

- [OpenTelemetry Introduction](./otel-introduction.md)
- [Install ElasticSearch](../../elasticsearch/)
