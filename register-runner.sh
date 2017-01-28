#!/bin/bash

yes '' | gitlab-runner register --url ${GITLAB_SERVICE_URL} --registration-token ${GITLAB_RUNNER_TOKEN} --executor docker --description "Docker Runner" --docker-image "docker:latest"
