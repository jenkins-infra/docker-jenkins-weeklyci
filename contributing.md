# Contributing Guidelines

This document outlines the process to update the docker images.

## scheduling
### For a recurring plugin update with no core
This can happend anytime, but make sure not to bump within a security of LTS release period.

### For a Core + Plugins update once a week after the weekly release on Tuesday
This should happend on wednesday morning (Paris time)

## Common process
for each plugin proposed for update we need to get the direct link to the changelog, for example for plugin `Matrix Authorization Strategy` the https://plugins.jenkins.io website bring the page `https://plugins.jenkins.io/matrix-auth/` where we can use either the release tab on top or the github link on the right : https://github.com/jenkinsci/matrix-auth-plugin
from there we get the specific release https://github.com/jenkinsci/matrix-auth-plugin/releases/tag/matrix-auth-3.2 this link is added in the PR review and we add a specific message to warn about the BREAKING change 💥 Major Changes 💥

the PR approuval comment might then looks like this :

- https://github.com/jenkinsci/aws-credentials-plugin/releases/tag/218.v1b_e9466ec5da_
- https://github.com/jenkinsci/inline-pipeline-plugin/releases/tag/inline-pipeline-1.0.3
- https://github.com/jenkinsci/kubernetes-plugin/releases/tag/4029.v5712230ccb_f8
- https://github.com/jenkinsci/kubernetes-client-api-plugin/releases/tag/6.8.1-224.vd388fca_4db_3b_

      💥 Breaking changes
```
    Kubernetes-client 6.8.1 comes with a number of breaking changes that downstream plugins must adapt to. As Jenkins users, please don't upgrade to this new version until all plugin consumers have released a new version claiming compatibility. The list of compatible plugins will be posted below when available.
```
- https://github.com/jenkinsci/kubernetes-credentials-plugin/compare/kubernetes-credentials-0.10.0...kubernetes-credentials-0.11
- https://github.com/jenkinsci/matrix-auth-plugin/releases/tag/matrix-auth-3.2
     ⚠️💥 Major Changes 💥
```
This release changes the syntax for configuring permissions with [Configuration as Code](https://plugins.jenkins.io/configuration-as-code/), [Job DSL](https://plugins.jenkins.io/job-dsl/), and [Pipeline](https://plugins.jenkins.io/workflow-aggregator/) plugins (https://github.com/jenkinsci/matrix-auth-plugin/pull/145, https://github.com/jenkinsci/matrix-auth-plugin/pull/144)

Warning
This is a breaking change for anyone currently configuring matrix authorization using these plugins.

In all three cases, the permissions list has been replaced with the entries list and a more elaborate element syntax decoupled from the serialized XML configuration format. See examples below for the new syntax.
```

- https://github.com/jenkinsci/workflow-api-plugin/releases/tag/1267.vd9b_a_ddd9eb_47
