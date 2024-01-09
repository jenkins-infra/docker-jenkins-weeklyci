# docker-jenkins

[![](https://img.shields.io/docker/pulls/jenkinsciinfra/jenkins?label=jenkinsciinfra%2Fjenkins&logo=docker&logoColor=white)](https://hub.docker.com/r/jenkinsciinfra/jenkins/tags)

A docker image containing the latest Jenkins LTS and Weekly releases, and the appropriate plugins depending on the controller.

The default image (`latest` tag) corresponds to the latest Jenkins LTS version and its plugins.

## Images and tags
- Jenkins LTS:
 - base
   - tag suffix: `-lts`
   - tags:
    - "docker.io/jenkinsciinfra/jenkins:latest",
    - "docker.io/jenkinsciinfra/jenkins:latest-lts",
    - "docker.io/jenkinsciinfra/jenkins:2.0.0-2.426.2",
    - "docker.io/jenkinsciinfra/jenkins:2.0.0-2.426.2-lts"

- Jenkins Weekly:
 - infra.ci.jenkins.io variant
   - tag suffix: `-weekly`
   - tags:
    - "docker.io/jenkinsciinfra/jenkins:latest-weekly",
    - "docker.io/jenkinsciinfra/jenkins:2.0.0-2.439",
    - "docker.io/jenkinsciinfra/jenkins:2.0.0-2.439-weekly"
 
 - weekly.ci.jenkins.io variant
   - Fewer plugins than infra.ci.jenkins.io
   - tag suffix: `-weeklyci`
   - tags:
    - "docker.io/jenkinsciinfra/jenkins:latest-weeklyci",
    - "docker.io/jenkinsciinfra/jenkins:2.0.0-2.439-weeklyci"

By default the Weekly image is built with infra.ci.jenkins.io in mind, but there is a variant for weekly.ci.jenkins.io with fewer plugins (defined in plugins-weekly_weekly.ci.jenkins.io.txt).
To use this variant, add `-weeklyci` as suffix to the tag, ex: `jenkinsciinfra/jenkins:2.0.0-2.439-weeklyci`

## Updating Plugins

```
bash ./bin/update-plugins.sh
```

This script uses the [Jenkins Plugin Manager Tool command line](https://github.com/jenkinsci/plugin-installation-manager-tool) under the hood to update the plugins.

## Update Jenkins Version

```
LTS_VERSION=$(jv get --version-identifier lts)
WEEKLY_VERSION=$(jv get --version-identifier latest)
SUFFIX=jdk17
FULL_LTS_VERSION=jenkins/jenkins:${LTS_VERSION}-${SUFFIX}
FULL_WEEKLY_VERSION=jenkins/jenkins:${WEEKLY_VERSION}-${SUFFIX}
sed -i 's|(JENKINS_LTS_VERSION".*default = ")[^"]+(")|\1${FULL_LTS_VERSION}\3|' docker-bake.hcl
sed -i 's|(JENKINS_WEEKLY_VERSION".*default = ")[^"]+(")|\1${FULL_WEEKLY_VERSION}\3|' docker-bake.hcl
```
