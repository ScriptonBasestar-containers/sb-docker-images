# CLAUDE.md - Development Tools

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Development & CI/CD Tools
**Projects**: 8 (Jenkins, Jupyter, Jupyter2, Ansible, Chef, Ruby-dev, Node-pnpm, Taiga)
**Focus**: CI/CD automation, development environments, project management

## Projects

1. **Jenkins** - CI/CD automation server
2. **Jupyter/Jupyter2** - Interactive computing notebooks
3. **Ansible-dev** - Ansible 2.18 development environment
4. **Chef-dev** - Chef DK 3.4.28 development
5. **Ruby-dev** - Ruby development environment
6. **Node-pnpm** - Node.js with pnpm (Debian, Alpine, Builder variants)
7. **Taiga** - Agile project management (Jira/Trello alternative)

## Technology Stack

- **CI/CD**: Jenkins (Java)
- **Notebooks**: Jupyter (Python)
- **Config Management**: Ansible, Chef
- **Languages**: Ruby, Node.js
- **Project Management**: Taiga (Python/Django)

## Configuration Patterns

```bash
# Jenkins
JENKINS_ADMIN_USER=admin
JENKINS_ADMIN_PASSWORD=change_me
JENKINS_OPTS=--prefix=/jenkins

# Jupyter
JUPYTER_TOKEN=secure_token_here
JUPYTER_ENABLE_LAB=yes

# Taiga
TAIGA_SECRET_KEY=random_secret
TAIGA_DB_NAME=taiga
```

## CI/CD Best Practices

- **Pipeline as Code**: Jenkinsfile in repos
- **Credentials**: Secure credential management
- **Agents**: Scalable agent pools
- **Plugins**: Minimal, vetted plugins only

---

**Category**: devtools
**Last Updated**: 2025-12-28
