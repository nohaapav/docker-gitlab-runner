#!/usr/bin/env bash
set -x

pid=0
token=()
gitlab_service_url=http://${GITLAB_HOST}

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  gitlab-runner unregister -u ${gitlab_service_url} -t ${token}
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; term_handler' SIGTERM

# register runner
yes '' | gitlab-runner register --url ${gitlab_service_url} \
                                --registration-token ${GITLAB_RUNNER_TOKEN} \
                                --executor docker \
                                --name "runner" \
                                --output-limit "20480" \
                                --docker-image "docker:latest" \
                                --docker-volumes /root/m2:/root/.m2 \
                                --docker-extra-hosts ${GITLAB_HOST}:${GITLAB_IP}

# assign runner token
token=$(cat /etc/gitlab-runner/config.toml | grep token | awk '{print $3}' | tr -d '"')

# run multi-runner
gitlab-ci-multi-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner & pid="$!"

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
