# IMAGE_NAME defines the name of the image name.
# It's made up of 2 parts:
#
#  (1) The path to the production docker registry it lives in (991815424517.dkr.ecr.us-east-1.amazonaws.com)
#  (2) The name of the image (php-rest-api)
#
# If the image is going to be used in development the registry can be omitted
# (Staging/prod images need to live in ECR so this must)
#
# CHANGEME: give your application a unique IMAGE_NAME

# We push to a temporary ci registry. The CI_DOCKER_REGISTRY variable comes from gitlab

# Default settings (when building locally)
AWS_REGISTRY=991815424517.dkr.ecr.us-east-1.amazonaws.com
NPM_REGISTRY="artifact-repository.internal.tulip.io/repository/npm-hosted/"
GIT_COMMIT_SHA=$(shell git rev-parse HEAD)
GIT_AUTHOR=$(shell git show -s --format='%ae' $(CI_COMMIT_SHA))
GIT_BRANCH=$(shell git name-rev --name-only HEAD | sed "s/~.*//")
BUILD_HOST=$(shell hostname)
BUILD_DATE="$(shell date +'%a %b %d %T %Y %Z')"

# Variables that are overwritten by the CI system
CI_COMMIT_SHA := $(if $(CI_COMMIT_SHA),$(CI_COMMIT_SHA),$(GIT_COMMIT_SHA))
CI_COMMIT_REF_NAME := $(if $(CI_COMMIT_REF_NAME),$(CI_COMMIT_REF_NAME),$(GIT_BRANCH))
GITLAB_USER_ID := $(if $(GITLAB_USER_ID),$(GITLAB_USER_ID),$(GIT_AUTHOR))
CI_REGISTRY := $(if $(CI_DOCKER_REGISTRY),$(CI_DOCKER_REGISTRY),$(AWS_REGISTRY))
IMAGE_NAME=${CI_REGISTRY}/eslint_config

help:    ## Show this help.
	    @fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fg

## Docker Commands
## ====================
##

# Sbow the docker label
label:
	@echo "Label will contain:"
	@echo "CI_COMMIT_SHA: $(CI_COMMIT_SHA)"
	@echo "CI_COMMIT_REF_NAME: $(CI_COMMIT_REF_NAME)"
	@echo "GITLAB_USER_ID: $(GITLAB_USER_ID)"
	@echo "BUILD_HOST: $(BUILD_HOST)"
	@echo "BUILD_DATE: $(BUILD_DATE)"

.PHONY: build
build:  ## build the package
	npm run build

install:  ## build the package
	npm install 

tag:    ## tag the built image with the tag name (make tag tag_name=xxx)
	docker tag $(IMAGE_NAME):dev $(IMAGE_NAME):$(TAG_NAME)

push:   ## push the given tag to the container registry (make push tag_name=xxx)
	docker push $(IMAGE_NAME):$(TAG_NAME)

## Testing
## ===============
##
tests: ## Run unit tests
	echo "Running tests in container $(IMAGE_NAME):dev"
	docker run $(IMAGE_NAME):dev --rm sh -c "cd /tmp/es3lint-tulip && npm run test"

## CI Commands
## ==============
##
ci-test: ## Build bot testing stage
	echo "Running tests in a container"
	#docker run $(IMAGE_NAME):dev sh -c "cd /tmp/sdk && npm run test"

ci-build:  ## build the image
	docker build \
  --build-arg CI_COMMIT_SHA=$(CI_COMMIT_SHA) \
  --build-arg CI_COMMIT_REF_NAME=$(CI_COMMIT_REF_NAME) \
  --build-arg GITLAB_USER_ID=$(GITLAB_USER_ID) \
  --build-arg BUILD_HOST=$(BUILD_HOST) \
  --build-arg BUILD_DATE=$(BUILD_DATE) \
  --build-arg CI_NPM_AUTH_TOKEN=$(CI_NPM_AUTH_TOKEN) \
  -t $(IMAGE_NAME):$(CI_COMMIT_SHA) -f Dockerfile .

ci-push:
	docker push $(IMAGE_NAME):$(CI_COMMIT_SHA)

ci-publish:
	docker run \
  -e CI_NPM_AUTH_TOKEN=$(CI_NPM_AUTH_TOKEN) \
	-e NPM_REGISTRY=$(NPM_REGISTRY) \
	--rm \
  $(IMAGE_NAME):$(CI_COMMIT_SHA) \
  sh -c "echo "registry=https://${NPM_REGISTRY}" > /root/.npmrc && \
  echo "//${NPM_REGISTRY}:_authToken=NpmToken.${CI_NPM_AUTH_TOKEN}" >> /root/.npmrc && \
  cd /tmp/eslint_config && \
	npm publish --registry=https://${NPM_REGISTRY}"
