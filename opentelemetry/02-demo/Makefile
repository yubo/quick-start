.PHONY: start stop clean bash log

start:
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop

clean:
	docker-compose down

sh:
	docker exec -it 02-demo_term_1 sh

log:
	docker-compose logs -f

