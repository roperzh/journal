watch:
	hugo server --buildDrafts --verbose --config="config_${l}.toml"

build:
	hugo --verbose --config="config_${l}.toml"
