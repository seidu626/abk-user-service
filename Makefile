NAME	:= xper626/abk-user-service
WK_DIR	:= .
SOURCE	:= Dockerfile
TAG		:= $$(git log -1 --pretty=%H)
IMG		:= ${NAME}:${TAG}
LATEST	:= ${NAME}:latest

build:
	$(call blue, "Working dir: ${WK_DIR} ..")
	$(call blue, "Building:  ${IMG}")
	@cd ${WK_DIR} && \
	protoc --proto_path=. --micro_out=. --go_out=. \
		proto/auth/auth.proto && \
	docker build -t ${IMG} -f ${SOURCE} . && \
	docker tag ${IMG} ${LATEST}

push:
	$(call blue, "Pushing:  ${NAME}")
	@docker push ${NAME}

run:
	docker run --net="host" \
		-p 50051 \
		-e DB_HOST=localhost \
		-e DB_PASS=password \
		-e DB_USER=postgres \
		-e MICRO_SERVER_ADDRESS=:50051 \
		-e MICRO_REGISTRY=mdns \
		${NAME}

deploy:
	sed "s/{{ UPDATED_AT }}/$(shell date)/g" ./deployments/deployment.tmpl > ./deployments/deployment.yml
	kubectl replace -f ./deployments/deployment.yml
