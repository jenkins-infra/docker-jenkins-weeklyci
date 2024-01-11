#!/usr/bin/env bash

set -x

# List of files requiring a build
files_requiring_a_build=("cst.yaml" "docker-bake.hcl" "Dockerfile" "Jenkinsfile_k8s" "plugins-infra.ci.jenkins.io.txt" "plugins-weekly.ci.jenkins.io.txt" "logos/beekeeper.png" "logos/buttler_jenkins_is_the_way.png" "logos/buttler_stay_safe.png")

# List of modified files which reference depends if in a pull request or not
reference="origin/main..HEAD"
if [[ "${CHANGE_ID}" == "" ]]; then
    reference="HEAD^..HEAD"
fi
modified_files=($(git --no-pager diff "${reference}" --name-only))

# Find the intersection between them
intersection=""
for file in "${modified_files[@]}"; do
    if [[ "${files_requiring_a_build[@]}" =~ "${file}" ]]; then
        intersection="${intersection}${file}"
    fi
done

# Target everything by default
target="default"

# No target if there is no file requiring a build
if [[ "${intersection}" == "" ]]; then
    echo ""
    exit 0
fi

# Target infra-ci if only its plugins list has been modified
if [[ "${intersection}" == "plugins-infra.ci.jenkins.io.txt" ]]; then
    target="infra-ci"
fi

# Target weekly-ci if only its plugins list has been modified
if [[ "${intersection}" == "plugins-weekly.ci.jenkins.io.txt" ]]; then
    target="weekly-ci"
fi

echo "${target}"
