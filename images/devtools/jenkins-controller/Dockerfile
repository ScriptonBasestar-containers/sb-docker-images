ARG JENKINS_VERSION=2.528.3-jdk21
FROM jenkins/jenkins:${JENKINS_VERSION}
ARG JENKINS_CORE=2.528.3

# Metadata
LABEL maintainer="archmagece"
LABEL description="Jenkins Controller with pre-installed plugins"

# Copy plugin list
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install plugins at build time
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Disable Setup Wizard
RUN echo "${JENKINS_CORE}" > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    echo "${JENKINS_CORE}" > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion
