ARG JENKINS_VERSION=2.412.2
FROM jenkins/jenkins:"${JENKINS_VERSION}"-jdk17

ARG PLUGINS_FILE=plugins-lts.txt
COPY logos /usr/share/jenkins/ref/userContent/logos
COPY "${PLUGINS_FILE}" /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --verbose
