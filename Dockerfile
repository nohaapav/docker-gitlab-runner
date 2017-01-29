FROM gitlab/gitlab-runner
MAINTAINER Pavol Noha <pavol.noha@gmail.com>

ADD runner.sh /runner.sh
RUN chmod +x /runner.sh

ENTRYPOINT ["/runner.sh"]

