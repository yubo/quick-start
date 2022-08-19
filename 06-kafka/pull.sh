#!/bin/env bash
docker exec -it kafka1 \
kafka-console-consumer --bootstrap-server kafka1:9091 \
                       --topic quickstart \
                       --from-beginning
