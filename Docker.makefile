NS ?= geekmuse
VERSION ?= latest
APP_NAME ?= 101-todo

.DEFAULT_GOAL := help

.PHONY: build
build:			## Builds a local image.
	@docker build -t $(NS)/$(APP_NAME):$(VERSION) -f Dockerfile .

.PHONY: build-nc
build-nc:		## Builds a local image (no cache).
	@docker build --no-cache -t $(NS)/$(APP_NAME):$(VERSION) -f Dockerfile .

.PHONY: push
push:			## Pushes the local image to the authenticated registry.
	@docker push $(NS)/$(APP_NAME):$(VERSION)

.PHONY: release
release: build-nc push		## Release an image to registry, tagged with $VERSION.

.PHONY: run
run:			## Runs the image locally (make sure env vars are set appropriately).
	@docker run --rm -dp 3000:3000 --name $(APP_NAME) \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "SNS_TOPIC_ARN_DEFAULT=${SNS_TOPIC}" \
		-e "AWS_REGION=${AWS_REGION}" \
		$(NS)/$(APP_NAME):$(VERSION)

.PHONY: stop
stop:			## Stops a running container.
	-@docker kill $(APP_NAME)

.PHONY: clean
clean: stop 	## Removes any instances of the container.
	-@docker rm $(APP_NAME)

.PHONY: logs
logs:			## Tails the running container's logs.
	@docker logs $(APP_NAME) --follow

.PHONY: help
help:			## This help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
