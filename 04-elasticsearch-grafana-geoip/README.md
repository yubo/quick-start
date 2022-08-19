# otelcol & elasticsearch & grafana & geoip

- otelcol 采集 nginx 日志后，存储到 elasticsearch
- elasticsearch 收到数据后，使用 geoip plugin 处理数据
- grafana 从 elasticsearch 中获取数据，根据geoip数据渲染地图

## Preinstall

参考 [elasticsearch](../elasticsearch) 进行安装

如果已有 elaticsearch， 修改 [.env](./.env)


## Install 

```
# install
docker-compose up -d

# uninstall
docker-compose down
```

## Config

#### elasticsearch
https://www.elastic.co/guide/en/elasticsearch/reference/current/ingest.html

```
# 创建/更新 
PUT _ingest/pipeline/geoip
{
  "description" : "Add geoip info",
  "processors" : [
    {
      "geoip" : {
        "field" : "ip"
      }
    }
  ]
}

# 测试
POST _ingest/pipeline/geoip/_simulate
{
  "docs": [
    {
      "_source": {
          "ip": "89.160.20.128"
      }
    }
  ]
}

# 设置 index 的 default_pipeline
PUT test/_settings
{
  "index.default_pipeline": "geoip"
}
# 查看 test 设置
GET test/_settings

# 删除 default_pipeline
PUT test/_settings
{
  "index.default_pipeline": null
}

# 添加一条记录
POST test/_doc/2
{
  "ip": "89.160.20.128"
}

# 查看
GET test/_doc/2
>>>
{
  "_index" : "test",
  "_id" : "2",
  "_version" : 2,
  "_seq_no" : 12212,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "geoip" : {
      "continent_name" : "Europe",
      "region_iso_code" : "SE-AB",
      "city_name" : "Södertälje",
      "country_iso_code" : "SE",
      "country_name" : "Sweden",
      "region_name" : "Stockholm County",
      "location" : {
        "lon" : 17.6319,
        "lat" : 59.1951
      }
    },
    "ip" : "89.160.20.128"
  }
}
```

#### grafana


## 参考
- https://www.elastic.co/guide/en/kibana/current/docker.html
- https://www.ruanyifeng.com/blog/2017/08/elasticsearch.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/geoip-processor.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-geohashgrid-aggregation.html
