# open-telemetry

```
  +---------------+                                                    +---------------+
  | node-exporter +----+                                           +---+ ElasticSearch |
  +---------------+    |                                           |   +---------------+
                       |                                           |
                       |                                           |
         +--------+    |  +------------+        +--------------+   |   +------------+    +---------+
         | my-app +----+--+ otel-agent +--------+ otel-gateway +---+---+ Prometheus +----+ Grafana |
         +--------+    |  +------------+        +--------------+   |   +------------+    +---------+
                       |                                           |
                       |                                           |
        +---------+    |                                           |   +--------+
        | filelog +----+                                           +---+ Jaeger |
        +---------+                                                    +--------+
```

### 准备 elastic

- [安装 elasticsearch](../../elasticsearch/), 如果已有es，跳过这一步
- 为 es 创建, 创建 index
  ```
  curl -X GET -u elastic:admin1234 'http://localhost:9200/test'
  ```



### 配置 otel-collector-config.yaml

- 配置 [.env](./.env)
  ``` 
  ELASTIC_ENDPOINT=http://es01:9200
  ELASTIC_INDEX=test
  ELASTIC_USER=elastic
  ELASTIC_PASSWORD=admin1234
  ```
- 配置 [docker-compose.yaml](./docker-compose.yaml)

### 使用
```
# 安装
make start

# 卸载
make clean
```

## 参考
- [OpenTelemetry Introduction](./otel-introduction.md)
- [Install ElasticSearch](../../elasticsearch/)
