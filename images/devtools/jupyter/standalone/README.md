# Jupyter Standalone - Full Stack Data Science Environment

완전한 독립 실행 가능한 Jupyter 데이터 과학 환경입니다.

## Overview

Jupyter Notebook은 데이터 분석, 과학 계산, 머신러닝을 위한 대화형 개발 환경입니다. 이 구성은 Python, R, Julia, TensorFlow, Spark 등 다양한 데이터 과학 도구를 포함한 올인원 환경을 제공합니다.

### Features

- **Multiple Language Kernels**: Python 3, R, Julia, PySpark
- **Data Science Stack**: NumPy, Pandas, Scikit-learn, TensorFlow
- **JupyterLab**: Modern web-based interface
- **Full-featured**: Visualization, ML, Big Data processing
- **Extensible**: Easy package installation
- **Persistent Storage**: Docker volumes for notebooks

## Quick Start

```bash
# 환경 변수 설정 (선택사항)
cp .env.example .env

# 이미지 빌드 (최초 1회)
make build

# Jupyter 시작
make up

# 액세스 토큰 확인
make token

# 브라우저에서 접속
# http://localhost:8888
```

## Access Information

| Service | URL | Description |
|---------|-----|-------------|
| Jupyter | `http://localhost:8888` | JupyterLab interface |

**Get Access Token:**
```bash
make token
```

## Available Commands

### Service Management

```bash
make build       # Build Jupyter image (first time only)
make up          # Start Jupyter
make down        # Stop Jupyter
make restart     # Restart Jupyter
make logs        # View logs
make ps          # Show running containers
make clean       # Remove all data (destructive)
```

### Jupyter Operations

```bash
make shell       # Access container shell
make token       # Show access URL and token
make kernels     # List available kernels
```

## Available Kernels

Check installed kernels:
```bash
make kernels
```

- **Python 3**: Full data science stack (NumPy, Pandas, Scikit-learn, TensorFlow)
- **R (IRKernel)**: Statistical computing with tidyverse
- **Julia**: High-performance scientific computing
- **PySpark**: Big data processing with Apache Spark

## Pre-installed Libraries

### Python

**Data Processing:**
- NumPy, Pandas, Dask
- H5py, HDF5
- SQLAlchemy

**Machine Learning:**
- Scikit-learn, TensorFlow
- Statsmodels
- Scikit-image

**Visualization:**
- Matplotlib, Seaborn
- Bokeh, ipywidgets

**Other:**
- Beautiful Soup (web scraping)
- SciPy (scientific computing)
- SymPy (symbolic math)

### R

- tidyverse (data manipulation)
- caret (machine learning)
- forecast (time series)
- ggplot2 (visualization)
- shiny (web apps)

### Julia

- IJulia (Jupyter kernel)
- HDF5 (data storage)

## Usage Examples

### Python - Data Analysis

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
df = pd.read_csv('data.csv')

# Explore
print(df.info())
print(df.describe())
df.head()

# Visualize
plt.figure(figsize=(10, 6))
sns.heatmap(df.corr(), annot=True)
plt.show()
```

### Python - Machine Learning

```python
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Train model
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)

# Evaluate
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)
print(f'Accuracy: {accuracy:.2%}')
```

### Python - Deep Learning (TensorFlow)

```python
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout

# Build model
model = Sequential([
    Dense(128, activation='relu', input_shape=(784,)),
    Dropout(0.2),
    Dense(64, activation='relu'),
    Dropout(0.2),
    Dense(10, activation='softmax')
])

# Compile
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# Train
model.fit(X_train, y_train, epochs=10, validation_split=0.2)

# Evaluate
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f'Test accuracy: {test_acc:.2%}')
```

### R - Statistical Analysis

```r
library(tidyverse)

# Load data
data <- read.csv('data.csv')

# Data manipulation
summary_data <- data %>%
  group_by(category) %>%
  summarise(
    mean_value = mean(value),
    sd_value = sd(value),
    count = n()
  )

# Visualization
ggplot(data, aes(x=x, y=y, color=category)) +
  geom_point(size=3) +
  geom_smooth(method='lm') +
  theme_minimal() +
  labs(title='Scatter Plot with Regression')
```

### Julia - Numerical Computing

```julia
using DataFrames, Plots, Statistics

# Create data
df = DataFrame(
    x = 1:100,
    y = randn(100)
)

# Statistics
println("Mean: ", mean(df.y))
println("Std: ", std(df.y))

# Plot
plot(df.x, df.y,
     label="Data",
     xlabel="X",
     ylabel="Y",
     title="Julia Plot")
```

### PySpark - Big Data

```python
from pyspark.sql import SparkSession

# Create Spark session
spark = SparkSession.builder \
    .appName("DataAnalysis") \
    .getOrCreate()

# Load data
df = spark.read.csv('large_data.csv', header=True, inferSchema=True)

# Process
result = df.groupBy('category') \
    .agg({'value': 'mean', 'count': 'sum'}) \
    .orderBy('category')

# Show
result.show()

# Stop
spark.stop()
```

## Installing Additional Packages

### Python Packages

**Temporary (in notebook cell):**
```python
!pip install package-name
```

**Persistent (via shell):**
```bash
make shell
pip install package-name
# or with conda:
conda install package-name
```

### R Packages

**In R kernel:**
```r
install.packages("package-name")
```

### Julia Packages

**In Julia kernel:**
```julia
using Pkg
Pkg.add("PackageName")
```

## Data Management

### Saving Notebooks

Notebooks are automatically saved in the Docker volume `jupyter-work`.

### Backing Up Notebooks

```bash
# Method 1: Copy from container
docker cp jupyter-notebook:/home/jovyan/work ./notebooks

# Method 2: Create backup archive
make shell
tar czf /tmp/notebooks-backup.tar.gz work/
exit
docker cp jupyter-notebook:/tmp/notebooks-backup.tar.gz .
```

### Restoring Notebooks

```bash
# Copy to container
docker cp ./notebooks jupyter-notebook:/home/jovyan/work

# Or restore from archive
docker cp notebooks-backup.tar.gz jupyter-notebook:/tmp/
make shell
cd /home/jovyan
tar xzf /tmp/notebooks-backup.tar.gz
```

### Using Local Directory

Modify `compose.yml` to mount local directory:

```yaml
volumes:
  - ./notebooks:/home/jovyan/work  # Local directory
  - jupyter-config:/home/jovyan/.jupyter
```

## Security

### Authentication

Always use a strong access token:

```bash
# Generate secure token
python -c "import secrets; print(secrets.token_urlsafe(32))"

# Set in .env
JUPYTER_TOKEN=your-generated-token
```

### Security Best Practices

1. **Never use empty token** (`JUPYTER_TOKEN=""`) in production
2. **Use HTTPS** with reverse proxy for remote access
3. **Restrict network access** - only expose on localhost
4. **Regular updates** - rebuild image for security patches
5. **Don't commit credentials** to notebooks
6. **Encrypt sensitive data** before storing

### Password Authentication

Alternative to token:

```bash
# Generate password hash
python -c "from notebook.auth import passwd; print(passwd('your-password'))"

# Use in .env
JUPYTER_PASSWORD='sha256:...'
```

## Performance Optimization

### Memory Limits

Add to `compose.yml`:

```yaml
deploy:
  resources:
    limits:
      memory: 8G
      cpus: '4'
```

### GPU Support (NVIDIA)

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu]
```

### Best Practices

- Close unused notebooks
- Clear output before saving large notebooks
- Restart kernel to free memory
- Use `%matplotlib inline` for plots
- Monitor resource usage: `docker stats jupyter-notebook`

## Troubleshooting

### Cannot Access Jupyter

```bash
# Check if running
make ps

# Get access URL with token
make token

# Check logs
make logs

# Restart
make restart
```

### Kernel Not Starting

```bash
# List available kernels
make kernels

# Check logs for errors
make logs

# Restart Jupyter
make restart

# Access shell to debug
make shell
jupyter kernelspec list
```

### Out of Memory

```bash
# Check resource usage
docker stats jupyter-notebook

# Close unused notebooks
# Restart kernel in notebook: Kernel > Restart

# Increase memory limit in compose.yml
# Then restart:
make down
make up
```

### Package Import Errors

```bash
# Restart kernel in notebook
# If persists, reinstall package:
make shell
pip install --force-reinstall package-name
```

### Permission Issues

```bash
# Match container user with host user
# Set in .env:
NB_UID=1000  # Your user ID (run: id -u)

# Restart
make down
make up
```

## Advanced Features

### JupyterLab Extensions

```bash
make shell

# Install extension
pip install jupyterlab-git
jupyter labextension install @jupyterlab/git

# Enable
jupyter serverextension enable --py jupyterlab_git
```

### Custom Jupyter Config

```bash
make shell

# Generate config
jupyter notebook --generate-config

# Edit config
nano ~/.jupyter/jupyter_notebook_config.py
```

### Multiple Python Environments

```bash
make shell

# Create new environment
conda create -n py38 python=3.8 ipykernel
conda activate py38
ipython kernel install --user --name=py38

# Now available in notebook kernel menu
```

## Exporting Notebooks

### HTML

File > Download as > HTML (.html)

### Python Script

File > Download as > Python (.py)

### PDF

File > Download as > PDF via LaTeX (requires LaTeX)

### Sharing

- **GitHub**: Push .ipynb files (GitHub renders them)
- **nbviewer**: https://nbviewer.org/
- **Binder**: https://mybinder.org/ (interactive)
- **Google Colab**: Upload .ipynb file

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `JUPYTER_PORT` | `8888` | Jupyter web interface port |
| `JUPYTER_TOKEN` | `change-me-secure-token` | Access token |
| `JUPYTER_ENABLE_LAB` | `yes` | Use JupyterLab (vs classic) |
| `NB_USER` | `jovyan` | Jupyter user |
| `NB_UID` | `1000` | User ID |
| `NB_GID` | `100` | Group ID |
| `GRANT_SUDO` | `no` | Grant sudo privileges |
| `TZ` | `Asia/Seoul` | Timezone |

## Volumes

| Volume | Path | Description |
|--------|------|-------------|
| `jupyter-work` | `/home/jovyan/work` | Notebooks and data |
| `jupyter-config` | `/home/jovyan/.jupyter` | Jupyter configuration |

## Network

| Network | Driver | Description |
|---------|--------|-------------|
| `jupyter-network` | `bridge` | Jupyter network |

## Architecture

```
┌─────────────────────────────┐
│   Web Browser               │
│   http://localhost:8888     │
└──────────┬──────────────────┘
           │ HTTP (Port 8888)
           ▼
┌─────────────────────────────┐
│   JupyterLab Container      │
│  ┌─────────────────────┐    │
│  │  Python 3 Kernel    │    │
│  │  R Kernel           │    │
│  │  Julia Kernel       │    │
│  │  PySpark Kernel     │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  Notebooks          │    │
│  │  (jupyter-work)     │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

## Image Information

This standalone configuration uses a custom-built image:
- **Base**: jupyter/all-spark-notebook
- **Kernels**: Python 3, R, Julia, PySpark
- **Libraries**: Complete data science stack
- **Build**: Requires `make build` on first run

## References

- [Jupyter Official](https://jupyter.org/)
- [JupyterLab Documentation](https://jupyterlab.readthedocs.io/)
- [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)
- [NumPy Documentation](https://numpy.org/doc/)
- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Scikit-learn Documentation](https://scikit-learn.org/stable/)
- [TensorFlow Documentation](https://www.tensorflow.org/)
- [PySpark Documentation](https://spark.apache.org/docs/latest/api/python/)
- [Port Guide](../../docs/PORT_GUIDE.md)
- [Main README](../README.md)
