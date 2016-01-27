watch:
	hugo server --buildDrafts --verbose --config="config_${l}.toml"

build:
	hugo --verbose --config="config_${l}.toml"

deploy: build
	netlify deploy -s journal-${l} -p ./public/${l}

deploy-all:
	make deploy l=en
	make deploy l=es
