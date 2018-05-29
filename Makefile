dpl ?= deploy.env
include $(dpl)
ENVIRONMENT=$(shell sed 's/=.*//' $(dpl));
export ENVIRONMENT

BUILD_NUMBER ?= local-build
GIT_COMMIT ?= local-commit
BRANCH_NAME ?= local-branch

build: export COMPOSE_FILE=docker-compose.base.yml
build: repo-login
build:
	docker-compose build \
			--pull \
			healthcheck-test

# Tagging
tag-latest:
	docker tag $(COMPOSE_PROJECT_NAME)_$(IMAGE_NAME) $(REGISTRY_URI)/$(IMAGE_NAME):$(BRANCH_NAME)-latest

tag-commit:
	docker tag $(COMPOSE_PROJECT_NAME)_$(IMAGE_NAME) $(REGISTRY_URI)/$(IMAGE_NAME):git-$(GIT_COMMIT)


# Publishing

publish-latest: tag-latest
	docker push $(REGISTRY_URI)/$(IMAGE_NAME):$(BRANCH_NAME)-latest

publish-commit: tag-commit
	docker push $(REGISTRY_URI)/$(IMAGE_NAME):git-$(GIT_COMMIT)

publish: repo-login publish-latest publish-commit

# generate script to login to aws docker repo
CMD_REPOLOGIN := "eval $$\( aws ecr"
ifdef AWS_CLI_PROFILE
CMD_REPOLOGIN += " --profile $(AWS_CLI_PROFILE)"
endif
ifdef AWS_CLI_REGION
CMD_REPOLOGIN += " --region $(AWS_CLI_REGION)"
endif
CMD_REPOLOGIN += " get-login --no-include-email \)"

# login to AWS-ECR
repo-login: ## Auto login to AWS-ECR unsing aws-cli
	@eval $(CMD_REPOLOGIN)