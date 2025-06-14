FROM python:3.12-slim

ARG PORT=3141
ARG INSTALL_WEB=true
ARG INSTALL_CONSTRAINED=false
ARG INSTALL_FINDLINKS=false
ARG INSTALL_JENKINS=false
ARG INSTALL_LOCKDOWN=false

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install setuptools with fixed version to avoid pkg_resources deprecation warning
# /usr/local/lib/python3.12/site-packages/pyramid/path.py:3: UserWarning: pkg_resources is deprecated as an API. See https://setuptools.pypa.io/en/latest/pkg_resources.html. The pkg_resources package is slated for removal as early as 2025-11-30. Refrain from using this package or pin to Setuptools<81.
# FIXME: 위 문제가 해결되면 제거
RUN pip install --no-cache-dir "setuptools<81.0.0"

# Install core and optional plugins from PyPI
RUN pip install --no-cache-dir devpi-server devpi-client && \
    if [ "$INSTALL_WEB" = "true" ]; then pip install --no-cache-dir devpi-web; fi && \
    if [ "$INSTALL_CONSTRAINED" = "true" ]; then pip install --no-cache-dir devpi-constrained; fi && \
    if [ "$INSTALL_FINDLINKS" = "true" ]; then pip install --no-cache-dir devpi-findlinks; fi && \
    if [ "$INSTALL_JENKINS" = "true" ]; then pip install --no-cache-dir devpi-jenkins; fi && \
    if [ "$INSTALL_LOCKDOWN" = "true" ]; then pip install --no-cache-dir devpi-lockdown; fi

# devpi-semantic-ui 설치 후 테마 파일 복사
# RUN pip install --no-cache-dir devpi-semantic-ui && \
#     mkdir -p /app/semantic-ui && \
#     python -c "import devpi_semantic_ui, shutil, os; shutil.copytree(os.path.join(os.path.dirname(devpi_semantic_ui.__file__), 'semantic-ui'), '/app/semantic-ui', dirs_exist_ok=True)"

# Create non-root user
RUN groupadd -r devpi && useradd -r -g devpi devpi

# Create necessary directories
RUN mkdir -p /app/data /app/logs && \
    chown -R devpi:devpi /app

# Copy entrypoint script
COPY files/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set working directory and permissions
WORKDIR /app
USER devpi

# Expose port and healthcheck
EXPOSE ${PORT}
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT}/ || exit 1

VOLUME ["/app/data"]

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["devpi-server", "--host=0.0.0.0", "--port=3141", "--serverdir=/app/data", "--secretfile=/app/data/.secret"]
# CMD ["devpi-server", "--host=0.0.0.0", "--port=3141", "--serverdir=/app/data"]
# CMD ["devpi-server", "--host=0.0.0.0", "--port=3141", "--serverdir=/app/data", "--theme=semantic-ui"]