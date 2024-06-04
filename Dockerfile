FROM jenkins/jenkins:2.461-jdk17

ARG PLUGINS_FILE=plugins-infra.ci.jenkins.io.txt
COPY logos /usr/share/jenkins/ref/userContent/logos
COPY ${PLUGINS_FILE} /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --verbose
