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
  curl -X PUT -u elastic:admin1234 'http://localhost:9200/test'
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

## 日志数据
```
# 日志从agent所在容器的/testdata/*.log采集得到
echo '2023-03-10 INFO hello,world' >> testdata/test.log

# 从
agent_1    | 2022-03-10T05:29:33.104Z   INFO    loggingexporter/logging_exporter.go:69  LogsExporter    {"#logs": 1}
gateway_1  | 2022-03-10T05:29:33.226Z   INFO    loggingexporter/logging_exporter.go:69  LogsExporter    {"#logs": 1}

# 在es里查看日志
$ curl -X GET "localhost:9200/test/_search?from=0&size=1&pretty" -u elastic:admin1234 -H 'Content-Type: application/json' -d '
{
   "query": {
     "match": {
       "Body.msg": "hello,world"
     }
   }
}'
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 10,
      "relation" : "eq"
    },
    "max_score" : 19.77348,
    "hits" : [
      {
        "_index" : "test",
        "_id" : "W0VNcn8Bo0lFIjito1Eu",
        "_score" : 19.77348,
        "_source" : {
          "@timestamp" : "2023-03-10T00:00:00.000000000Z",
          "Attributes.file.name" : "test.log",
          "Body.msg" : "hello,world",
          "SeverityNumber" : 9,
          "SeverityText" : "Info",
          "TraceFlags" : 0
        }
      }
    ]
  }
}
```

## 时序数据

```sh
# send metric data to otel-agent.statsd from shell
$ echo "test.metric:42|g|#myKey:myVal" | nc -w 1 -u localhost 8125

# 查询 prometheus __name__
$ curl -s http://localhost:9090/api/v1/label/__name__/values | jq .  | grep test
"test_metric",
```

#### metrics 聚合

## trace 数据

## 参考
- [OpenTelemetry Introduction](./otel-introduction.md)
- [Install ElasticSearch](../../elasticsearch/)
