FROM jenkins/jenkins:2.295-jdk11

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --verbose

COPY --chown=jenkins:jenkins ./groovy-scripts/weather.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
