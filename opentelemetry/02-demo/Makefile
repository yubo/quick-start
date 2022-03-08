.PHONY: start stop clean bash log

start:
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop

clean:
	docker-compose down

bash:
	docker exec -it demo2 bash

log:
	docker-compose logs -f

