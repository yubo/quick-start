#!/bin/env bash
docker exec -it kafka1 \
	kafka-consumer-groups  --bootstrap-server localhost:9091 --list
