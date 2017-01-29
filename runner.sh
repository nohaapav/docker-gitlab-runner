#!/usr/bin/env bash
set -x

pid=0
token=()

# SIGTERM-handler
term_handler() {
  gitlab-runner unregister -u ${GITLAB_SERVICE_URL} -t ${token}
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; term_handler' SIGTERM

# register runner
yes '' | gitlab-runner register --url ${GITLAB_SERVICE_URL} --registration-token ${GITLAB_RUNNER_TOKEN} --executor docker --name "runner" --docker-image "docker:latest"

# assign runner token
token=$(cat /etc/gitlab-runner/config.toml | grep token | awk '{print $3}' | tr -d '"')

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
