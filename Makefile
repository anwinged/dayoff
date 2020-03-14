ifneq ($(STAGE), prod)
	PATH := tools:$(PATH)
endif

APP_NAME := dayoff
ENTRY_POINT = ./src/$(APP_NAME).cr

.PHONY: build-docker
build-docker:
	docker build --file docker/Dockerfile.dev --tag $(APP_NAME)-crystal --tag anwinged/$(APP_NAME)-crystal .

install-shards:
	shards install

update-shards:
	shards update

.PHONY: install
install: build-docker install-shards install-assets build-assets

.PHONY: build
build:
	mkdir -p build
	crystal build $(ENTRY_POINT) --release --no-debug --static -o build/$(APP_NAME)

.PHONY: format
format:
	crystal tool format ./src ./spec

install-assets:
	nodejs npm install

build-assets:
	rm -rf ./public/assets
	nodejs npm run-script build

watch-assets:
	rm -rf ./public/assets
	nodejs npm run-script watch

format-assets:
	nodejs npm run-script format-webpack || true
	nodejs npm run-script format-js || true
	nodejs npm run-script format-vue || true

.PHONY: run
run: format
	crystal run $(ENTRY_POINT)

.PHONY: run-server
run-server: format
	mkdir -p ./var/data
	BASE_PATH="./var/data" server run $(ENTRY_POINT)

.PHONY: spec
spec: format
	crystal spec --warnings all --error-on-warnings --error-trace

.PHONY: ameba
ameba:
	ameba src/ || true
