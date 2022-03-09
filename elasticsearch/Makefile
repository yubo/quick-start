.PHONY: start stop clean bash
all: start

start:
	docker-compose up -d

stop:
	docker-compose stop

clean:
	docker-compose down
	docker volume rm elasticsearch_certs elasticsearch_esdata01 elasticsearch_esdata02 elasticsearch_esdata03 elasticsearch_kibanadata

bash:
	docker exec -it elasticsearch_es01_1 bash
