#!/bin/env bash
docker exec --interactive --tty kafka1 \
kafka-console-producer --bootstrap-server kafka1:9091 \
                       --topic quickstart


