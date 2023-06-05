# open-telemetry

#### [01-otel-jaeger-promethues](./01-otel-jaeger-promethues)
```
                                                          +--------+
         +-------------+                               +--+ Zipkin |
         | demo-client +-----+                         |  +--------+
         +-------------+     |                         |
                             |                         |
                             |    +----------------+   |  +------------+      +---------+
                             +----+ otel-collector +---+--+ Prometheus +------+ Grafana |
                             |    +----------------+   |  +------------+      +---------+
                             |                         |
         +-------------+     |                         |
         | demo-server +-----+                         |  +--------+
         +-------------+                               +--+ Jaeger |
                                                          +--------+
```

#### [02-otel-agent-gateway-prometheus](./02-otel-agent-gateway-prometheus)
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

- [OpenTelemetry Introduction](./otel-introduction.md)
