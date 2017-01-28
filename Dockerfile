FROM gitlab/gitlab-runner
MAINTAINER Pavol Noha <pavol.noha@gmail.com>

ADD register-runner.sh /register-runner.sh
RUN chmod +x /register-runner.sh

ENTRYPOINT ["/register-runner.sh"]
