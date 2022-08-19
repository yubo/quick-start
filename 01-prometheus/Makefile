.PHONY: start stop clean sh
all: start

start:
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop

clean:
	docker-compose down
	#docker volume rm prometheus_prometheus_data
