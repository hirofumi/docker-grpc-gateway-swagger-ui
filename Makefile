test:
	docker compose -f docker-compose.test.yml run --rm sut

.PHONY: test
