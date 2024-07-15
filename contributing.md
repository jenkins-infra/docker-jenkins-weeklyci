# Contributing Guidelines

This document outlines the process to update the docker images.

## Scheduling

### For Plugin Update without Core Update

It can happen at anytime, but avoid merging during a security advisory or LTS Core release period.

### For a Core Update (With or without Plugins Update)

- Default: Every Wednesday on mornings (Paris time)
  - Caused by the weekly core release happening on Tuesdays

- Delayed on Wednesday evenings (Paris time) or even Thursday when there is a LTS Core release / security advisory

## Common Process

For each plugin proposed for update we need to:

- Get the direct link to the changelog from the [plugins.jenkins.io website](https://plugins.jenkins.io): search for the plugin to get to the a top "Release" tab, locate the version and retrieve the permalink (usually a GitHub release)
  - For instance with the plugin [`Matrix Authorization Strategy`](https://plugins.jenkins.io/matrix-auth/), with version 3.2, you get the following link: <https://github.com/jenkinsci/matrix-auth-plugin/releases/tag/matrix-auth-3.2>

- If this plugin version changelog has a breaking or "💥 Major Changes 💥" change, add this link with a message mentioning the breaking change as a PR comment

Example of a PR approval comment:

```text
- 💥 Breaking changes on https://github.com/jenkinsci/kubernetes-client-api-plugin/releases/tag/6.8.1-224.vd388fca_4db_3b_:

>  Kubernetes-client 6.8.1 comes with a number of breaking changes that downstream plugins must adapt to. As Jenkins users, please don't upgrade to this new version until all plugin consumers have released a new version claiming compatibility. The list of compatible plugins will be posted below when available.

- ⚠️💥 Major Changes 💥 on https://github.com/jenkinsci/matrix-auth-plugin/releases/tag/matrix-auth-3.2:

> This release changes the syntax for configuring permissions with [Configuration as Code](https://plugins.jenkins.io/configuration-as-code/), [Job DSL](https://plugins.jenkins.io/job-dsl/), and [Pipeline](https://plugins.jenkins.io/workflow-aggregator/) plugins (https://github.com/jenkinsci/matrix-auth-plugin/pull/145, https://github.com/jenkinsci/matrix-auth-plugin/pull/144)
>
> Warning
> This is a breaking change for anyone currently configuring matrix authorization using these plugins.
>
> In all three cases, the permissions list has been replaced with the entries list and a more elaborate element > syntax decoupled from the serialized XML configuration format. See examples below for the new syntax.
```
