watch:
	hugo server --buildDrafts --verbose --config="config_${l}.toml"

build:
	hugo --verbose --config="config_${l}.toml"

build-all:
	rm -rf public
	make build l=en
	make build l=es

deploy: build-all
	netlify deploy -s journal -p public