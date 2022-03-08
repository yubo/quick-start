.PHONY: start stop clean

start:
	docker-compose up -d

stop:
	docker-compose stop

clean:
	docker-compose down
	docker volume rm elasticsearch_certs elasticsearch_esdata01 elasticsearch_esdata02 elasticsearch_esdata03 elasticsearch_kibanadata
