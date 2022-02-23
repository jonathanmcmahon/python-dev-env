PACKAGE_NAME=api

ENV_PATH=.venv

TEST_COVERAGE_CMD=$(ENV_PATH)/bin/coverage

LATEST_GIT_TAG=$(shell git describe --abbrev=0 --tags)
LATEST_COMMIT=$(shell git rev-parse --short HEAD)

IMAGE_REGISTRY_URI=someaccount.dkr.ecr.us-east-1.amazonaws.com
IMAGE_NAME=fastcompany/$(PACKAGE_NAME)
VERSION?=$(LATEST_GIT_TAG)-$(LATEST_COMMIT)
IMAGE_REPO_URI=$(IMAGE_REGISTRY_URI)/$(IMAGE_NAME)
IMAGE_FULL_TAG?=$(IMAGE_REPO_URI):$(VERSION)
DOCKER_ARGS=

LISTEN_IP=127.0.0.1
LISTEN_PORT=5000
DB_PORT?=5432

AWS_SECRET_ACCESS_KEY?=
AWS_ACCESS_KEY_ID?=


all: install

install:
	virtualenv -p python3 $(ENV_PATH)
	$(ENV_PATH)/bin/pip install -r requirements.txt

test:
	#$(ENV_PATH)/bin/python -m pytest tests/
	-$(TEST_COVERAGE_CMD) run --omit=".venv/*","tests/*" -m pytest ./tests/ -v

coverage:
	 $(TEST_COVERAGE_CMD) html
	 $(ENV_PATH)/bin/python -mwebbrowser file://$(PWD)/htmlcov/index.html

qc: format-code lint-code lint-docstring

lint-code:
	-$(ENV_PATH)/bin/pylint $(PACKAGE_NAME)

format-code:
	$(ENV_PATH)/bin/black --line-length 80 .

lint-docstring:
	-$(ENV_PATH)/bin/pep257

# NON-PROD ONLY: Run the application for local development in debug mode
run:
	$(ENV_PATH)/bin/gunicorn -b $(LISTEN_IP):$(LISTEN_PORT) $(PACKAGE_NAME):__hug_wsgi__

docker: build

build.txt:
	date -u > build.txt

build: clean Dockerfile build.txt
	@echo Building $(IMAGE_FULL_TAG) ...
	docker build \
		$(DOCKER_ARGS) \
		--build-arg APP_VERSION=$(LATEST_COMMIT) \
		--label "version=$(LATEST_COMMIT)" \
		-t $(IMAGE_FULL_TAG) \
		-f Dockerfile .
	@echo Build complete.

# Run api locally in a container
docker-run:
	docker run -d \
		--rm \
		--name $(PACKAGE_NAME) \
		-p $(LISTEN_PORT):$(LISTEN_PORT) \
		$(IMAGE_FULL_TAG)

docker-export:
	@echo Exporting $(IMAGE_FULL_TAG)
	docker save $(IMAGE_FULL_TAG) | gzip -c > $(IMAGE_NAME)_$(LATEST_GIT_TAG).tar.gz

push:
	@echo Pushing $(IMAGE_FULL_TAG) ...
	docker push $(IMAGE_FULL_TAG)

promote: push
	@echo Promoting $(IMAGE_FULL_TAG) to latest ...
	docker tag $(IMAGE_FULL_TAG) $(IMAGE_REPO_URI):latest
	docker push $(IMAGE_REPO_URI):latest

clean:
	rm -rf build.txt
