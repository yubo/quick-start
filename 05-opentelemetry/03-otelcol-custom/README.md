## build otelcol-custom

- edit [otelcol-builder.yaml](./otelcol-builder.yaml)

- create es.index
  ```
  curl -X PUT -u elastic:admin1234 'http://localhost:9200/test'
  ```

- build
  ```
  make
  ```
