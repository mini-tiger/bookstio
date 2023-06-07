ITERATION=1.0
REVIEW_URL=./reviews/reviews-wlpcfg
USER_ID=local
APP_PATH=/usr/local/bin
IMAGE_HUB=harbor.dev.21vianet.com/bookinfo

.PHONY: details ratings page

build: reviews-v1 reviews-v2 reviews-v3 ratings page details

reviews-v1: 
	docker build -t $(USER_ID)/reviews-v1:$(ITERATION) $(REVIEW_URL)

reviews-v2: 
	docker build -t $(USER_ID)/reviews-v2:$(ITERATION) --build-arg service_version=v2 --build-arg enable_ratings=true --build-arg star_color=black $(REVIEW_URL)

reviews-v3: 
	docker build -t $(USER_ID)/reviews-v3:$(ITERATION) --build-arg service_version=v3 --build-arg enable_ratings=true --build-arg star_color=red $(REVIEW_URL)

ratings:  
	docker build -t $(USER_ID)/ratings:$(ITERATION) ./ratings

page: 
	docker build -t $(USER_ID)/productpage:$(ITERATION) ./productpage

details: 
	docker build -t $(USER_ID)/details:$(ITERATION) ./details

run: 
	docker-compose up -d

commit: build
	docker push $(USER_ID)/reviews-v1:$(ITERATION)
	docker push $(USER_ID)/reviews-v2:$(ITERATION)
	docker push $(USER_ID)/reviews-v3:$(ITERATION)
	docker push $(USER_ID)/ratings:$(ITERATION)
	docker push $(USER_ID)/details:$(ITERATION)
	docker push $(USER_ID)/productpage:$(ITERATION)
	
login:
	@echo -n "Please input Dockerhub "
	@docker login -u $(USER_ID)

push: login commit

Install_kind:
	curl -k https://minitor-minio-api.dev.21vianet.com/public/kind_0.11.1 -o $(APP_PATH)/kind
	chmod +x $(APP_PATH)/kind

Install_kubectl:
	curl -k https://minitor-minio-api.dev.21vianet.com/public/kubectl_1.20.7 -o $(APP_PATH)/kubectl
	chmod +x $(APP_PATH)/kubectl

Install_helm: 
	curl -k https://minitor-minio-api.dev.21vianet.com/public/helm -o $(APP_PATH)/helm
	chmod +x $(APP_PATH)/helm

Install_istio: 
	curl -k https://minitor-minio-api.dev.21vianet.com/public/istioctl_1.6.8 -o $(APP_PATH)/istioctl
	chmod +x $(APP_PATH)/istioctl

pull_images:
	docker pull $(IMAGE_HUB)/istio/proxyv2:1.6.8
	docker pull $(IMAGE_HUB)/grafana/grafana:6.7.4
	docker pull $(IMAGE_HUB)/prom/prometheus:v2.15.1
	docker pull $(IMAGE_HUB)/istio/pilot:1.6.8
	docker pull $(IMAGE_HUB)/jaegertracing/all-in-one:1.16
	docker pull $(IMAGE_HUB)/kiali/kiali:v1.18