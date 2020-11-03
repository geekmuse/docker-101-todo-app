
.DEFAULT_GOAL := help

.PHONY: deps
deps:			## Install production deps.
	@yarn install --production

.PHONY: deps-dev
deps-dev:		## Install all deps (including dev).
	@yarn install

.PHONY: dev
dev:			## Use npm to spin up local dev server.
	AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
		SNS_TOPIC_ARN_DEFAULT="${SNS_TOPIC}" \
		AWS_REGION="${AWS_REGION}" \
		SQLITE_DB_LOCATION='./todos.db' \
		npm run dev

.PHONY: help
help:			## This help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
