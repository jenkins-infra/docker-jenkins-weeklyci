#!/usr/bin/env bash

set -ex

cd "$(dirname "$0")" || exit 1

echo "Updating plugins"

# Fetches the latest plugin manager version via API, the asset has a version number in it unfortunately
# So we can't just use the API to get the latest version without some parsing
PM_CLI_DOWNLOAD_URL=$(curl -s 'https://api.github.com/repos/jenkinsci/plugin-installation-manager-tool/releases/latest' | jq -r '.assets[] | select(.content_type=="application/java-archive").browser_download_url')

TMP_DIR=$(mktemp -d)

wget --no-verbose "${PM_CLI_DOWNLOAD_URL}" -O "${TMP_DIR}/jenkins-plugin-manager.jar"

CURRENT_JENKINS_VERSION=$(head -n 1 ../Dockerfile | cut -d ':' -f 2 | cut -d '-' -f 1)
wget --no-verbose "https://get.jenkins.io/war/${CURRENT_JENKINS_VERSION}/jenkins.war" -O "${TMP_DIR}/jenkins.war"

cd ../ || exit 1

java -jar "${TMP_DIR}/jenkins-plugin-manager.jar" -f plugins.txt --available-updates --output txt --war "${TMP_DIR}/jenkins.war"  > plugins2.txt

mv plugins2.txt plugins.txt

## Generate a patch without comments removal(s)
# the first sed removes the comments removal(s) from the patch
# the second sed fixes the patch by keeping the same amount of context before and after, since plugins are only updated and not removed with this script
git diff  -p --stat plugins.txt | sed -r 's/-#/ #/' | sed -r 's/@@ -([0-9]+),([0-9]+) \+([0-9]+),[0-9]+/@@ -\1,\2 +\3,\2/' > patch-plugins-only.txt
# Restore plugins.txt and apply the modified patch or log its content and exit if it's corrupted
git restore plugins.txt
git apply patch-plugins-only.txt || cat patch-plugins-only.txt && exit 1
# Remove the patch
rm patch-plugins-only.txt

git diff plugins.txt

echo "Updating plugins complete"

rm -rf "${TMP_DIR}"
