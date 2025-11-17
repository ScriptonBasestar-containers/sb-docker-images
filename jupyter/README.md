# Jupyter Notebook - Full Stack

다양한 언어 커널을 포함한 Full Stack Jupyter Notebook 환경

## 개요

Jupyter Notebook은 데이터 분석, 과학 계산, 머신러닝을 위한 대화형 개발 환경입니다. 이 이미지는 Python, R, Julia, Tensorflow, Spark 등 다양한 데이터 과학 도구를 포함한 올인원 Notebook 환경을 제공합니다.

## 특징

- **Python 3**: 데이터 과학 라이브러리 전체 스택
- **R**: IRKernel과 tidyverse, caret 등 주요 패키지
- **Julia**: IJulia 커널 및 HDF5 지원
- **TensorFlow**: 딥러닝 프레임워크
- **Apache Spark**: 빅데이터 처리
- **데이터 과학 패키지**:
  - NumPy, Pandas, Matplotlib, Seaborn
  - Scikit-learn, SciPy
  - Beautiful Soup, SQLAlchemy
  - Dask, H5py, HDF5
- **포트**: 8888 (기본 Jupyter 포트)

## Standalone Configuration

완전한 독립 실행 가능한 Jupyter 데이터 과학 환경 구성이 `standalone/` 디렉토리에 제공됩니다.

### Features

- **Multi-Language**: Python, R, Julia, PySpark 커널
- **JupyterLab**: 현대적인 웹 인터페이스
- **Full Stack**: NumPy, Pandas, TensorFlow, Scikit-learn
- **환경 변수 지원**: .env 파일을 통한 유연한 설정
- **완전한 문서**: 사용 예시, 패키지 설치, 데이터 관리

### Usage

```bash
# standalone 디렉토리로 이동
cd standalone/

# 환경 변수 설정 (선택사항)
cp .env.example .env

# 이미지 빌드 (최초 1회)
make build

# Jupyter 시작
make up

# 액세스 토큰 확인
make token
```

자세한 내용은 [standalone/README.md](./standalone/README.md)를 참조하세요.

## 빠른 시작

### 이미지 빌드

```bash
# 이미지 빌드
docker build -t jupyter-fullbook .

# 캐시 없이 빌드
docker build --no-cache -t jupyter-fullbook .
```

### 기본 실행

```bash
# Jupyter Notebook 시작
docker run --rm -p 8888:8888 jupyter-fullbook

# 웹 브라우저에서 접속
# http://localhost:8888
# 토큰은 컨테이너 로그에서 확인
```

### 포트 변경

```bash
# 다른 포트로 실행 (호스트:컨테이너)
docker run --rm -p 8080:8888 jupyter-fullbook
```

### 작업 디렉토리 마운트

```bash
# 현재 디렉토리 마운트
docker run --rm \
  -p 8888:8888 \
  -v $(pwd):/home/jovyan/work \
  jupyter-fullbook

# 특정 디렉토리 마운트
docker run --rm \
  -p 8888:8888 \
  -v /path/to/notebooks:/home/jovyan/work \
  jupyter-fullbook
```

## 서비스 구성

### 포트 정보

| 포트 | 용도 | 설명 |
|------|------|------|
| 8888 | Jupyter Notebook | 웹 인터페이스 |

> **포트 충돌 방지**: 다른 프로젝트와 동시 실행 시 포트를 변경하세요.
> PORT_GUIDE.md에서 jupyter는 8888, jupyter2는 8889를 사용하도록 권장됩니다.
>
> 자세한 내용은 [PORT_GUIDE.md](../docs/PORT_GUIDE.md)를 참조하세요.

### 볼륨

- `/home/jovyan/work`: 작업 디렉토리 (노트북 저장)
- `/home/jovyan/.jupyter`: Jupyter 설정 디렉토리

### 사용자

- 기본 사용자: `jovyan` (UID: 1000)
- root 권한: `--user root` 옵션으로 실행 가능

## 환경 변수

```bash
# Jupyter 토큰 설정
docker run --rm \
  -p 8888:8888 \
  -e JUPYTER_TOKEN=mysecret \
  jupyter-fullbook

# 비밀번호 없이 실행 (보안 주의!)
docker run --rm \
  -p 8888:8888 \
  -e JUPYTER_ENABLE_LAB=yes \
  -e JUPYTER_TOKEN="" \
  jupyter-fullbook

# sudo 권한 부여
docker run --rm \
  -p 8888:8888 \
  -e GRANT_SUDO=yes \
  --user root \
  jupyter-fullbook
```

## 디렉토리 구조

```
jupyter/
├── Dockerfile          # Full stack Jupyter 이미지
└── README.md           # 이 문서
```

## 사용법

### 1. 기본 사용

```bash
# 컨테이너 시작
docker run --rm -p 8888:8888 -v $(pwd):/home/jovyan/work jupyter-fullbook

# 브라우저에서 접속
# 로그에서 토큰 확인:
# http://127.0.0.1:8888/?token=abc123...
```

### 2. 대화형 쉘 접속

```bash
# bash 쉘 실행
docker run -it --rm \
  -p 8888:8888 \
  -v $(pwd):/home/jovyan/work \
  jupyter-fullbook bash

# 컨테이너 내에서
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
```

### 3. 커널 확인

```bash
# 설치된 커널 목록 확인
docker run -it --rm jupyter-fullbook jupyter kernelspec list

# 출력 예:
# Available kernels:
#   ir         /opt/conda/share/jupyter/kernels/ir
#   julia-1.7  /opt/conda/share/jupyter/kernels/julia-1.7
#   python3    /opt/conda/share/jupyter/kernels/python3
```

### 4. Python 패키지 사용

```python
# Notebook에서 실행
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# 데이터 로드
df = pd.read_csv('data.csv')
df.head()

# 시각화
plt.figure(figsize=(10, 6))
sns.heatmap(df.corr(), annot=True)
plt.show()
```

### 5. R 사용

```r
# R 커널에서 실행
library(tidyverse)
library(caret)

# 데이터 로드
data <- read.csv('data.csv')
head(data)

# 시각화
ggplot(data, aes(x=x, y=y)) + geom_point()
```

### 6. Julia 사용

```julia
# Julia 커널에서 실행
using DataFrames
using Plots

# 데이터 생성
df = DataFrame(x = 1:10, y = rand(10))
plot(df.x, df.y)
```

### 7. TensorFlow 사용

```python
import tensorflow as tf
import numpy as np

# 간단한 모델
model = tf.keras.Sequential([
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(10, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# 학습
# model.fit(x_train, y_train, epochs=5)
```

## 포함된 주요 패키지

### Python 라이브러리

**데이터 처리**
- pandas, numpy, numexpr
- dask, cloudpickle
- h5py, hdf5

**머신러닝**
- scikit-learn
- scikit-image
- statsmodels
- tensorflow
- numba

**시각화**
- matplotlib
- seaborn
- bokeh
- ipywidgets

**기타**
- beautifulsoup4
- sqlalchemy
- xlrd
- sympy, scipy
- cython, protobuf

### R 패키지

- **tidyverse**: 데이터 처리 및 시각화
- **caret**: 머신러닝
- **forecast**: 시계열 분석
- **shiny**: 웹 애플리케이션
- **devtools**: 개발 도구
- **IRKernel**: Jupyter R 커널
- **rmarkdown**: 리포팅
- **tidymodels** (x86_64만)

### Julia 패키지

- **IJulia**: Jupyter Julia 커널
- **HDF5**: 데이터 저장

### 시스템 도구

- fonts-dejavu
- unixodbc, r-cran-rodbc
- gfortran, gcc
- ffmpeg (matplotlib 애니메이션용)

## 문제 해결

### 토큰을 모르겠어요

```bash
# 로그에서 토큰 확인
docker logs <container-id>

# 또는 컨테이너 내부에서
jupyter notebook list
```

### 포트가 이미 사용 중입니다

```bash
# 다른 포트 사용
docker run --rm -p 8889:8888 jupyter-fullbook

# 또는 실행 중인 컨테이너 확인
docker ps
docker stop <container-id>
```

### 패키지가 없습니다

```bash
# 컨테이너 내부에서 설치
docker run -it --rm --user root jupyter-fullbook bash

# conda로 설치
conda install package-name

# pip로 설치
pip install package-name

# 또는 Dockerfile 수정 후 재빌드
```

### 권한 문제

```bash
# root로 실행
docker run --rm -p 8888:8888 --user root jupyter-fullbook

# 볼륨 권한 설정
sudo chown -R 1000:1000 /path/to/notebooks
```

### Julia 커널이 보이지 않습니다

```bash
# 컨테이너 내부에서
jupyter kernelspec list

# Julia 커널 재설치
julia -e 'using Pkg; Pkg.add("IJulia")'
```

### R 패키지 설치 오류

```bash
# ARM 아키텍처에서 일부 패키지 설치 불가
# x86_64 시스템 사용 권장
```

## 고급 사용법

### 1. 커스텀 설정

```bash
# Jupyter 설정 디렉토리 마운트
docker run --rm \
  -p 8888:8888 \
  -v $(pwd):/home/jovyan/work \
  -v $(pwd)/.jupyter:/home/jovyan/.jupyter \
  jupyter-fullbook
```

### 2. 확장 기능 설치

```bash
# 컨테이너 내부에서
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
jupyter nbextension enable codefolding/main
```

### 3. JupyterLab 실행

```bash
docker run --rm \
  -p 8888:8888 \
  -v $(pwd):/home/jovyan/work \
  jupyter-fullbook \
  jupyter lab --ip=0.0.0.0 --port=8888 --allow-root
```

### 4. 멀티 Python 커널

```bash
# Python 2 커널 추가
conda create -n py27 python=2.7 ipykernel
conda activate py27
ipython kernel install --user

# Python 3.6 커널 추가
conda create -n py36 python=3.6 ipykernel
conda activate py36
ipython kernel install --user
```

### 5. Docker Compose 사용

```yaml
# docker-compose.yml
version: '3.8'

services:
  jupyter:
    image: jupyter-fullbook
    build: .
    ports:
      - "8888:8888"
    volumes:
      - ./notebooks:/home/jovyan/work
    environment:
      - JUPYTER_ENABLE_LAB=yes
      - JUPYTER_TOKEN=mysecret
    command: start-notebook.sh --NotebookApp.token='mysecret'
```

### 6. GPU 지원 (NVIDIA)

```bash
# NVIDIA Docker Runtime 필요
docker run --rm \
  --gpus all \
  -p 8888:8888 \
  -v $(pwd):/home/jovyan/work \
  jupyter-fullbook
```

## 데이터 과학 워크플로우

### 1. 데이터 로드 및 탐색

```python
import pandas as pd
import matplotlib.pyplot as plt

# CSV 로드
df = pd.read_csv('data.csv')

# 기본 정보
print(df.info())
print(df.describe())
df.head()
```

### 2. 데이터 전처리

```python
# 결측값 처리
df = df.dropna()
df = df.fillna(0)

# 데이터 타입 변환
df['date'] = pd.to_datetime(df['date'])

# 원핫 인코딩
df = pd.get_dummies(df, columns=['category'])
```

### 3. 시각화

```python
import seaborn as sns

# 분포 확인
plt.figure(figsize=(12, 6))
sns.histplot(df['value'])
plt.show()

# 상관관계
sns.heatmap(df.corr(), annot=True)
plt.show()
```

### 4. 머신러닝

```python
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

# 데이터 분할
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# 모델 학습
model = RandomForestClassifier()
model.fit(X_train, y_train)

# 평가
score = model.score(X_test, y_test)
print(f'Accuracy: {score:.2f}')
```

## 참고 자료

- [Jupyter 공식 문서](https://jupyter.org/documentation)
- [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)
- [Jupyter Notebook 확장](https://github.com/ipython-contrib/jupyter_contrib_nbextensions)
- [Python 2/3 커널 사용](https://stackoverflow.com/questions/30492623/using-both-python-2-x-and-python-3-x-in-ipython-notebook)
- [Jupyter 확장 추천](https://ndres.me/post/best-jupyter-notebook-extensions/)

## 관련 프로젝트

- [jupyter2](../jupyter2/README.md) - Jupyter Lab (다중 언어)
- [devpi](../devpi/README.md) - Python 패키지 서버

## 베이스 이미지

- jupyter/all-spark-notebook
- jupyter/minimal-notebook

## 라이선스

Jupyter 프로젝트는 BSD 라이선스를 따릅니다.
