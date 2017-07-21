all: build
build: 
	docker build -t nohaapav/docker-gitlab-runner:ersteapi . 
