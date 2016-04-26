watch:
	hugo server --buildDrafts --verbose --config="config_${l}.toml"

watch-expose:
	hugo server --verbose --config="config_${l}.toml" \
	--bind="${url}" --baseURL="${url}/${l}"

build:
	hugo --verbose --config="config_${l}.toml"

build-all:
	rm -rf public
	make build l=en
	make build l=es

deploy: build-all
	cp static/_redirects public
	netlify deploy -s journal -p ./public/