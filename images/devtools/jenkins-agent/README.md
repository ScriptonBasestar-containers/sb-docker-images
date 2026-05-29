# Jenkins Agent

Inbound Jenkins agent image with Docker CLI for building containers.

## Features

- Inbound agent base image
- JDK 21 runtime
- Docker CLI installed (for use with mounted Docker socket)

## Usage

### Build

```bash
make build
```

### Push

```bash
make push
```

## Notes

- For Docker builds, mount `/var/run/docker.sock` into the agent pod/container.
