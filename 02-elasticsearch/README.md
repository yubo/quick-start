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

## 访问

#### elasticsearch

```
url: http://localhost:9200
usr: elastic
pwd: admin1234
```

#### kibana

```
url: http://localhost:5601
usr: elastic
pwd: admin1234
```

## 参考
- https://www.elastic.co/guide/en/kibana/current/docker.html
