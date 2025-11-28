asdf_install:
	asdf install

mix_deps_get:
	mix deps.get

mix_setup:
	mix setup

dev_compose_up:
	docker-compose up --force-recreate --wait

dev_compose_down:
	docker-compose down --remove-orphans

init: asdf_install mix_deps_get dev_compose_up mix_setup

start: dev_compose_up
	mix ecto.setup
	mix phx.server

stop: dev_compose_down

load_start:
	docker-compose -f docker-compose-load-test.yaml up --force-recreate --wait influxdb grafana
	docker-compose -f docker-compose-load-test.yaml run --rm -T k6 run /scripts/script.js

load_stop:
	docker-compose -f docker-compose-load-test.yaml down --remove-orphans

clean: load_stop stop
