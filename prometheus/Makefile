.PHONY: start stop clean
all: start
	docker-compose up -d --remove-orphans

stop:
	docker-compose stop

clean:
	docker-compose down
