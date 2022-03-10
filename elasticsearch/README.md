# Install ES

```
docker network create elastic
```


## docker-compose

```
# install
docker-compose up -d

# uninstall
docker-compose down
```

## docker
#### install
```
docker run --network=elastic --network-alias=es-node01 --name es-node01 -p 9200:9200 -p 9300:9300 -t docker.elastic.co/elasticsearch/elasticsearch:8.0.1

docker run --network=elastic --network-alias=kib-01 --name kib-01 -p 5601:5601 docker.elastic.co/kibana/kibana:8.0.1
```

#### uninstall
```
docker rm es-node01
docker rm kib-01
```

## 参考
- https://www.elastic.co/guide/en/kibana/current/docker.html
