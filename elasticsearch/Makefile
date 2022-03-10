.PHONY: start stop clean sh
all: start

start:
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop

clean:
	docker-compose down
	docker volume rm elasticsearch_certs elasticsearch_esdata01 elasticsearch_esdata02 elasticsearch_esdata03 elasticsearch_kibanadata

sh:
	docker exec -it elasticsearch_term_1 sh
