# Jenkins Controller

Pre-installed plugin Jenkins Controller image.

## Features

- Build-time plugin installation (no runtime downloads)
- Setup Wizard disabled
- JCasC (Configuration as Code) support

## Usage

### Build

```bash
make build
```


### Push

```bash
make push
```

### Test

```bash
make test
# Open http://localhost:8080
make test-stop
```

## Included Plugins

- **Core**: workflow-aggregator, credentials, credentials-binding, configuration-as-code
- **SCM**: git, github, gitlab-plugin
- **Kubernetes**: kubernetes
- **Pipeline**: job-dsl, build-timeout, pipeline-utility-steps, pipeline-stage-view
- **UI**: blueocean
- **Integration**: generic-webhook-trigger, prometheus
- **Utilities**: timestamper, warnings-ng, role-strategy, ssh-credentials

## Helm Chart Integration

Use with sb-helm-charts Jenkins chart:

```yaml
image:
  registry: harbor.polypia.in
  repository: library/jenkins-controller
  tag: "2.528.3-jdk21"

# Plugins are baked into the image, so disable runtime install
controller:
  installPlugins: false
```

## Versions

- Jenkins: 2.528.3
- JDK: 21
