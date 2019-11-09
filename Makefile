PATH := tools:$(PATH)
APP_NAME := dayoff
ENTRY_POINT = ./src/$(APP_NAME).cr

.PHONY: build-docker
build-docker:
	docker pull alpine:edge
	docker build -t $(APP_NAME)-crystal .

install-shards:
	shards install

.PHONY: install
install: build-docker install-shards

.PHONY: build
build:
	mkdir -p build
	crystal build $(ENTRY_POINT) --release --no-debug --static -o build/$(APP_NAME)

.PHONY: format
format:
	crystal tool format ./src ./spec

build-assets:
	rm -rf ./public/assets
	nodejs npm run-script build

format-assets:
	nodejs npm run-script format-webpack || true
	nodejs npm run-script format-js || true
	nodejs npm run-script format-vue || true

.PHONY: run
run: format
	crystal run $(ENTRY_POINT)

.PHONY: run-server
run-server: format
	BASE_PATH="./tmp" server run $(ENTRY_POINT)

.PHONY: spec
spec: format
	crystal spec --warnings all --error-on-warnings --error-trace

.PHONY: ameba
ameba:
	ameba src/ || true
