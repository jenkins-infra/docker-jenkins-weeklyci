# docker-jenkins-weekly

a docker image containing the latest jenkins weekly release and plugins

## Updating Plugins

```
uc update --determine-version-from-docker-file --display-updates -w
```

## Update Jenkins Version

```
VERSION=$(jv get --version-identifier latest)
SUFFIX=jdk11
FULL_VERSION=jenkins/jenkins:${{ steps.update.outputs.jenkins_version }}-${SUFFIX}
sed -i 's|FROM .*|FROM '"${FULL_VERSION}"'|' Dockerfile
```
