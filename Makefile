test:
	docker-compose -f docker-compose.test.yml run --build --rm sut

.PHONY: test
