#!/bin/env bash
docker exec kafka1 \
kafka-topics --bootstrap-server kafka1:9091 \
             --create \
             --topic quickstart
