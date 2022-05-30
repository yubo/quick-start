.PHONY: start stop clean sh
all: start

start:
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop

clean:
	docker-compose down

sh:
	docker exec -it elasticsearch_term_1 sh
