FROM jenkins/jenkins:lts

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

COPY plugins/* /usr/share/jenkins/ref/plugins/*
USER root
RUN chown jenkins:jenkins -R /usr/share/jenkins/ref/plugins
USER jenkins
