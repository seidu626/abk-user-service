NAME	:= xper626/abk-user-service
SRV_NAME:= abk-user-service
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
		-p 50053:50051 \
		-e DB_HOST=postgres://ussd_airflow:__password__@172.19.0.2:5432 \
		-e MICRO_SERVER_ADDRESS=:50051 \
		-e MICRO_REGISTRY=mdns \
		${LATEST}

deploy:
	sed "s/{{ UPDATED_AT }}/$(shell date)/g" ./deployments/deployment.tmpl > ./deployments/deployment.yml
	kubectl replace -f ./deployments/deployment.yml
