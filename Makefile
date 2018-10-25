TAG=latest
BIN=kubewire
IMAGE=unchartedsky/$(BIN)

all: cleanall image

image:
	docker build -t $(IMAGE):$(TAG) ./docker

deploy: image
	docker push $(IMAGE):$(TAG)

run: image
	docker run --name=$(BIN) --cap-add=NET_ADMIN --cap-add=SYS_MODULE -p 5182:5182/udp -p 5182:5182/tcp --net=host -d --rm -it $(IMAGE):$(TAG)

	docker exec -it $(BIN) bash

.PHONY: clean

clean: ;

cleanall: clean ;

