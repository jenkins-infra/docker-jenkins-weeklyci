# docker-jenkins-weekly

[![](https://img.shields.io/docker/pulls/jenkinsciinfra/ldap?label=jenkinsciinfra%2Fjenkins-weekly&logo=docker&logoColor=white)](https://hub.docker.com/r/jenkinsciinfra/jenkins-weekly/tags)

A docker image containing the latest jenkins weekly release and plugins.

## Updating Plugins

```
bash ./bin/update-plugins.sh
```

This script uses the [Jenkins Plugin Manager Tool command line](https://github.com/jenkinsci/plugin-installation-manager-tool) under the hood to update the plugins.

## Update Jenkins Version

```
VERSION=$(jv get --version-identifier latest)
SUFFIX=jdk17
FULL_VERSION=jenkins/jenkins:${VERSION}-${SUFFIX}
sed -i 's|FROM .*|FROM '"${FULL_VERSION}"'|' Dockerfile
```
