#!/usr/bin/env bash

set -ex

cd "$(dirname "$0")" || exit 1

echo "Updating plugins"

# Fetches the latest plugin manager version via API, the asset has a version number in it unfortunately
# So we can't just use the API to get the latest version without some parsing
PM_CLI_DOWNLOAD_URL=$(curl -s 'https://api.github.com/repos/jenkinsci/plugin-installation-manager-tool/releases/latest' | jq -r '.assets[] | select(.content_type=="application/x-java-archive").browser_download_url')

TMP_DIR=$(mktemp -d)

wget --no-verbose "${PM_CLI_DOWNLOAD_URL}" -O "${TMP_DIR}/jenkins-plugin-manager.jar"

CURRENT_JENKINS_LTS_VERSION=$(grep 'variable "JENKINS_LTS_VERSION' docker-bake.hcl | cut -d ' ' -f 6 | cut -d '"' -f 2)
wget --no-verbose "https://get.jenkins.io/war/${CURRENT_JENKINS_LTS_VERSION}/jenkins.war" -O "${TMP_DIR}/jenkins-lts.war"

CURRENT_JENKINS_WEEKLY_VERSION=$(grep 'variable "JENKINS_WEEKLY_VERSION' docker-bake.hcl | cut -d ' ' -f 6 | cut -d '"' -f 2)
wget --no-verbose "https://get.jenkins.io/war/${CURRENT_JENKINS_WEEKLY_VERSION}/jenkins.war" -O "${TMP_DIR}/jenkins-weekly.war"

cd ../ || exit 1

# Iterate through each txt file starting with "plugins-"
for pluginfile in plugins-*.txt; do
    if [ -e "${pluginfile}" ]; then
        echo "Updating plugins file: ${pluginfile}"
        # Retrieve the release line from the plugins filename (plugins-lts* or plugins-weekly*)
        releaseline=$([[ $(echo "${pluginfile}"  | cut -d '-' -f 2 | cut -d '_' -f 1) = "lts" ]] && echo "-lts" || echo "-weekly")

        java -jar "${TMP_DIR}/jenkins-plugin-manager.jar" -f "${pluginfile}" --available-updates --output txt --war "${TMP_DIR}/jenkins-${releaseline}.war"  > plugins2.txt

        mv plugins2.txt "${pluginfile}"

        git diff "${pluginfile}"
    fi
done

rm -rf "${TMP_DIR}"

echo "Updating plugins complete"
