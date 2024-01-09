group "default" {
  targets = ["lts-base", "weekly-base"]
}

group "lts-base" {
  targets = ["lts"]
}

group "weekly-base" {
  targets = ["weekly_infra-ci", "weekly_weekly-ci"]
}

variable "IMAGE_DEPLOY_NAME" {}

variable "TAG_NAME" {
  default = ""
}

variable "REGISTRY" {
  default = "docker.io"
}

variable "PLUGINS_FILE" {
  default = "plugins-lts.txt"
}

# Keep these 2 declarations on one line each so ./bin/update-plugins.sh can easily retrieve these values
variable "JENKINS_LTS_VERSION" { default = "2.426.2" }
variable "JENKINS_WEEKLY_VERSION" { default = "2.439" }

target "base" {
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    JENKINS_VERSION = JENKINS_LTS_VERSION
  }
}

## Jenkins LTS variant
target "lts" {
  inherits = ["base"]
  tags = [
    "${REGISTRY}/${IMAGE_DEPLOY_NAME}:latest",
    "${REGISTRY}/${IMAGE_DEPLOY_NAME}:latest-lts",
    notequal("", TAG_NAME) ? "${REGISTRY}/${IMAGE_DEPLOY_NAME}:${TAG_NAME}-${JENKINS_LTS_VERSION}" : "",
    notequal("", TAG_NAME) ? "${REGISTRY}/${IMAGE_DEPLOY_NAME}:${TAG_NAME}-${JENKINS_LTS_VERSION}-lts" : ""
  ]
}

## Jenkins Weekly variants
target "weekly_infra-ci" {
  inherits = ["base"]
  args = {
    JENKINS_VERSION = JENKINS_WEEKLY_VERSION
    PLUGINS_FILE = "plugins-weekly_infra.ci.jenkins.io.txt",
  }
  tags = [
    "${REGISTRY}/${IMAGE_DEPLOY_NAME}:latest-weekly",
    notequal("", TAG_NAME) ? "${REGISTRY}/${IMAGE_DEPLOY_NAME}:${TAG_NAME}-${JENKINS_WEEKLY_VERSION}" : "",
    notequal("", TAG_NAME) ? "${REGISTRY}/${IMAGE_DEPLOY_NAME}:${TAG_NAME}-${JENKINS_WEEKLY_VERSION}-weekly" : ""
  ]
}

target "weekly_weekly-ci" {
  inherits = ["weekly_infra-ci"]
  args = {
    PLUGINS_FILE = "plugins-weekly_weekly.ci.jenkins.io.txt",
  }
  tags = [
    "${REGISTRY}/${IMAGE_DEPLOY_NAME}:latest-weeklyci",
    notequal("", TAG_NAME) ? "${REGISTRY}/${IMAGE_DEPLOY_NAME}:${TAG_NAME}-${JENKINS_WEEKLY_VERSION}-weeklyci" : ""
  ]
}
