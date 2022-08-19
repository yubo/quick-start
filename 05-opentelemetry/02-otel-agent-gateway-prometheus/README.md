# open-telemetry

服务
  - node-exporter: 9100
  - otel-agent: 8124/udp
  - prometheus: 9090
  - grafana: 3000
  - jaeger: 16686

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
- api http://localhost:9200
- https://www.elastic.co/guide/en/elasticsearch/reference/current/rest-apis.html
- kibana http://localhost:5601

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
   },
   "sort": {
     "@timestamp": {
        "order": "desc"
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
- http://localhost:9090
- https://prometheus.io/docs/prometheus/latest/querying/api/

```sh
# send metric data to otel-agent.statsd from shell
$ echo "test.metric:42|g|#myKey:myVal" | nc -w 1 -u localhost 8125

# 查询 prometheus __name__
$ curl -s http://localhost:9090/api/v1/label/__name__/values | jq .  | grep test
"test_metric",
```

#### metrics 聚合
- http://localhost:16686
- https://www.jaegertracing.io/docs/1.32/apis/

## trace 数据
```
$ curl http://localhost:16686/api/services
{"data":["jaeger-query","demo-client","demo-server"],"total":3,"limit":0,"offset":0,"errors":null}

$ curl http://localhost:16686/api/services/demo-client/operations
{"data":["ExecuteRequest","HTTP GET"],"total":2,"limit":0,"offset":0,"errors":null}

$ curl 'http://localhost:16686/api/traces?end=1646966801404000&limit=1&lookback=1h&maxDuration&minDuration&service=demo-client&start=1646963201404000'
{"data":[{"traceID":"300ca95ff12eb6eed03e862b8ac4c482","spans":[{"traceID":"300ca95ff12eb6eed03e862b8ac4c482","spanID":"f7f65087ad1d12b2","operationName":"ExecuteRequest","references":[],"startTime":1646966801307835,"duration":12615,"tags":[{"key":"otel.library.name","type":"string","value":"demo-client-tracer"},{"key":"span.kind","type":"string","value":"internal"},{"key":"internal.span.format","type":"string","value":"proto"}],"logs":[],"processID":"p1","warnings":null},{"traceID":"300ca95ff12eb6eed03e862b8ac4c482","spanID":"e2b95ce8aaf204ba","operationName":"HTTP GET","references":[{"refType":"CHILD_OF","traceID":"300ca95ff12eb6eed03e862b8ac4c482","spanID":"f7f65087ad1d12b2"}],"startTime":1646966801307895,"duration":12448,"tags":[{"key":"otel.library.name","type":"string","value":"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"},{"key":"otel.library.version","type":"string","value":"semver:0.29.0"},{"key":"http.method","type":"string","value":"GET"},{"key":"http.url","type":"string","value":"http://demo-server:7080/hello"},{"key":"http.scheme","type":"string","value":"http"},{"key":"http.host","type":"string","value":"demo-server:7080"},{"key":"http.flavor","type":"string","value":"1.1"},{"key":"http.status_code","type":"int64","value":200},{"key":"span.kind","type":"string","value":"client"},{"key":"internal.span.format","type":"string","value":"proto"}],"logs":[],"processID":"p1","warnings":null},{"traceID":"300ca95ff12eb6eed03e862b8ac4c482","spanID":"c30054efed5b7ee2","operationName":"/hello","references":[{"refType":"CHILD_OF","traceID":"300ca95ff12eb6eed03e862b8ac4c482","spanID":"e2b95ce8aaf204ba"}],"startTime":1646966801310995,"duration":8891,"tags":[{"key":"otel.library.name","type":"string","value":"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"},{"key":"otel.library.version","type":"string","value":"semver:0.29.0"},{"key":"net.transport","type":"string","value":"ip_tcp"},{"key":"net.peer.ip","type":"string","value":"192.168.224.8"},{"key":"net.peer.port","type":"int64","value":46300},{"key":"net.host.name","type":"string","value":"demo-server"},{"key":"net.host.port","type":"int64","value":7080},{"key":"http.method","type":"string","value":"GET"},{"key":"http.target","type":"string","value":"/hello"},{"key":"http.server_name","type":"string","value":"/hello"},{"key":"http.user_agent","type":"string","value":"Go-http-client/1.1"},{"key":"http.scheme","type":"string","value":"http"},{"key":"http.host","type":"string","value":"demo-server:7080"},{"key":"http.flavor","type":"string","value":"1.1"},{"key":"server-attribute","type":"string","value":"foo"},{"key":"http.wrote_bytes","type":"int64","value":11},{"key":"http.status_code","type":"int64","value":200},{"key":"span.kind","type":"string","value":"server"},{"key":"internal.span.format","type":"string","value":"proto"}],"logs":[],"processID":"p2","warnings":null}],"processes":{"p1":{"serviceName":"demo-client","tags":[{"key":"host.name","type":"string","value":"adc8ea0a87a1"},{"key":"process.command_args","type":"string","value":"[\"/go/bin/main\"]"},{"key":"process.executable.name","type":"string","value":"main"},{"key":"process.executable.path","type":"string","value":"/go/bin/main"},{"key":"process.owner","type":"string","value":"root"},{"key":"process.pid","type":"int64","value":1},{"key":"process.runtime.description","type":"string","value":"go version go1.17.8 linux/amd64"},{"key":"process.runtime.name","type":"string","value":"gc"},{"key":"process.runtime.version","type":"string","value":"go1.17.8"},{"key":"telemetry.sdk.language","type":"string","value":"go"},{"key":"telemetry.sdk.name","type":"string","value":"opentelemetry"},{"key":"telemetry.sdk.version","type":"string","value":"1.4.1"}]},"p2":{"serviceName":"demo-server","tags":[{"key":"host.name","type":"string","value":"42683dfae6d5"},{"key":"process.command_args","type":"string","value":"[\"/go/bin/main\"]"},{"key":"process.executable.name","type":"string","value":"main"},{"key":"process.executable.path","type":"string","value":"/go/bin/main"},{"key":"process.owner","type":"string","value":"root"},{"key":"process.pid","type":"int64","value":1},{"key":"process.runtime.description","type":"string","value":"go version go1.17.8 linux/amd64"},{"key":"process.runtime.name","type":"string","value":"gc"},{"key":"process.runtime.version","type":"string","value":"go1.17.8"},{"key":"telemetry.sdk.language","type":"string","value":"go"},{"key":"telemetry.sdk.name","type":"string","value":"opentelemetry"},{"key":"telemetry.sdk.version","type":"string","value":"1.4.1"}]}},"warnings":null}],"total":0,"limit":0,"offset":0,"errors":null}
```

## Grafana

#### 安装插件
```
docker-compose exec grafana grafana-cli plugins install grafana-worldmap-panel
docker-compose restart grafana
```

## 参考
- [OpenTelemetry Introduction](./otel-introduction.md)
- [Install ElasticSearch](../../elasticsearch/)
- https://github.com/open-telemetry/opentelemetry-log-collection/blob/main/docs/operators/regex_parser.md
- https://regex101.com/?flavor=golang
