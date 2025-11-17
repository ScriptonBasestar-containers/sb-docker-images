# Jupyter Lab - Multi-Language

JVM 언어(Scala, Groovy, Kotlin, Clojure), Python, R, Ruby 등 다중 언어를 지원하는 Jupyter Lab 환경

## 개요

Jupyter Lab은 Jupyter Notebook의 차세대 인터페이스로, 더 강력하고 유연한 환경을 제공합니다. 이 이미지는 Python뿐만 아니라 Scala, Ruby, R 등 다양한 프로그래밍 언어의 커널을 포함하여 데이터 과학, 머신러닝, 백엔드 개발까지 지원합니다.

## 특징

- **JupyterLab**: 차세대 Jupyter 인터페이스
- **다중 언어 커널**:
  - **Python 3**: 기본 데이터 과학 스택
  - **Scala 2.11/2.12/2.13**: Almond 커널
  - **Ruby 2.6.4**: IRuby 커널
  - **R**: IRKernel
  - **JVM 언어**: Groovy, Kotlin, Clojure (BeakerX)
- **데이터 과학 패키지**:
  - NumPy, Pandas, Matplotlib, Seaborn
  - Scikit-learn, SciPy, Statsmodels
  - Beautiful Soup, SQLAlchemy
  - Dask, H5py, Bokeh
- **개발 도구**:
  - Git, Vim, Tree
  - SDKMAN (Java, Scala)
  - Build tools
- **포트**: 8889 (기본 포트, 8888과 구분)

## 빠른 시작

### 이미지 빌드

```bash
# 이미지 빌드
docker build -t sb-jupyter .

# 캐시 없이 빌드
docker build --no-cache -t sb-jupyter .
```

### 기본 실행

```bash
# Jupyter Lab 시작
docker run --rm -it -p 8889:8888 sb-jupyter

# 또는 bash 쉘로 시작
docker run --rm -it -p 8889:8888 sb-jupyter bash
```

### Jupyter Lab 실행

```bash
# 컨테이너 내부 또는 시작 시
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root

# 웹 브라우저에서 접속
# http://localhost:8889
```

### 작업 디렉토리 마운트

```bash
# 현재 디렉토리 마운트
docker run --rm -it \
  -p 8889:8888 \
  -v $(pwd):/home/jovyan/work \
  sb-jupyter
```

## 서비스 구성

### 포트 정보

| 포트 | 용도 | 설명 |
|------|------|------|
| 8889 | Jupyter Lab | 웹 인터페이스 (호스트 포트) |
| 8888 | 내부 포트 | 컨테이너 내부 Jupyter 포트 |

> **포트 구분**:
> - jupyter (포트 8888): Jupyter Notebook Full Stack
> - jupyter2 (포트 8889): Jupyter Lab Multi-Language
>
> 두 서비스를 동시에 실행할 수 있도록 다른 포트를 사용합니다.
>
> 자세한 내용은 [PORT_GUIDE.md](../docs/PORT_GUIDE.md)를 참조하세요.

### 볼륨

- `/home/jovyan/work`: 작업 디렉토리
- `/home/jovyan/.jupyter`: Jupyter 설정
- `/home/jovyan/.local/share/jupyter/kernels`: 커널 설정

### 사용자

- 기본 사용자: `jovyan` (UID: 1000)
- root 권한: `--user root` 옵션으로 실행 가능

## 환경 변수

### 빌드 시 변수

```dockerfile
SCALA_11_VERSION=2.11.12        # Scala 2.11 버전
SCALA_12_VERSION=2.12.8         # Scala 2.12 버전
SCALA_13_VERSION=2.13.0         # Scala 2.13 버전
ALMOND_VERSION=0.6.0            # Almond 커널 버전
JAVA_VERSION=12                 # Java 버전
RUBY_VERSION=2.6.4              # Ruby 버전
```

### 런타임 변수

```bash
# Jupyter 토큰 설정
docker run --rm -it \
  -p 8889:8888 \
  -e JUPYTER_TOKEN=mysecret \
  sb-jupyter

# sudo 권한
docker run --rm -it \
  -p 8889:8888 \
  -e GRANT_SUDO=yes \
  --user root \
  sb-jupyter
```

## 디렉토리 구조

```
jupyter2/
├── Dockerfile                    # Jupyter Lab + 다중 언어
├── Dockerfile-debian             # Debian 기반 버전
├── Dockerfile-minimal-notebook   # 최소 버전
├── kernel.py2.json               # Python 2 커널 설정
├── kernel.ruby.json              # Ruby 커널 설정
├── kernel.scala.json             # Scala 커널 설정
├── sdkman.config                 # SDKMAN 설정
└── README.md                     # 이 문서
```

## 사용법

### 1. 커널 확인

```bash
# bash로 시작
docker run -it --rm -p 8889:8888 sb-jupyter bash

# 커널 목록 확인
jupyter kernelspec list

# 출력 예:
# Available kernels:
#   python3    /opt/conda/share/jupyter/kernels/python3
#   ir         /opt/conda/share/jupyter/kernels/ir
#   scala      /home/jovyan/.local/share/jupyter/kernels/scala
#   ruby       /home/jovyan/.local/share/jupyter/kernels/ruby
```

### 2. Jupyter Lab 시작

```bash
# 컨테이너 내부에서
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root

# 또는 Jupyter Notebook
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
```

### 3. Python 사용

```python
# Python 3 커널에서
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 데이터 분석
df = pd.DataFrame({
    'x': range(10),
    'y': np.random.randn(10)
})

plt.plot(df.x, df.y)
plt.show()
```

### 4. Scala 사용

```scala
// Scala 커널에서
import $ivy.`org.scalanlp::breeze:1.0`
import breeze.linalg._

val x = DenseVector.rand(5)
val y = DenseVector.rand(5)
val dotProduct = x dot y

println(s"Dot product: $dotProduct")
```

### 5. Ruby 사용

```ruby
# Ruby 커널에서
require 'json'

data = {
  name: 'Alice',
  age: 30,
  skills: ['Ruby', 'Python', 'Scala']
}

puts JSON.pretty_generate(data)
```

### 6. R 사용

```r
# R 커널에서
library(ggplot2)

data <- data.frame(
  x = 1:10,
  y = rnorm(10)
)

ggplot(data, aes(x=x, y=y)) +
  geom_line() +
  geom_point()
```

### 7. JVM 언어 (BeakerX)

```groovy
// Groovy
def greet(name) {
    println "Hello, ${name}!"
}
greet("World")
```

```kotlin
// Kotlin
fun factorial(n: Int): Int {
    return if (n <= 1) 1 else n * factorial(n - 1)
}
println("5! = ${factorial(5)}")
```

## 포함된 주요 패키지

### Python 라이브러리

**데이터 과학**
- pandas=0.25.*, numpy
- scipy=1.3.*, statsmodels=0.10.*
- scikit-learn=0.21.*, scikit-image=0.15.*
- numba=0.45.*, numexpr=2.6.*

**시각화**
- matplotlib-base=3.1.*
- seaborn=0.9.*
- bokeh=1.3.*
- ipywidgets=7.5.*

**데이터 처리**
- beautifulsoup4=4.8.*
- sqlalchemy=1.3.*
- h5py=2.9.*, hdf5=1.10.*
- dask=2.2.*, cloudpickle=1.2.*
- xlrd

**기타**
- cython=0.29.*, protobuf=3.9.*
- sympy=1.4.*, vincent=0.4.*

### R 패키지 (IRKernel)

R 커널 지원 (기본 설치)

### Scala/JVM

- **Scala**: 2.11.12, 2.12.8, 2.13.0
- **Almond**: 0.6.0 (Scala 커널)
- **Java**: 12
- **BeakerX**: JVM 언어 커널
- **Coursier**: Scala 의존성 관리

### Ruby

- **Ruby**: 2.6.4
- **IRuby**: Jupyter Ruby 커널

### 시스템 도구

- sudo, tree, vim
- git, zip, unzip, curl
- build-essential
- ffmpeg, gfortran, gcc
- fonts-dejavu

## 문제 해결

### 커널이 보이지 않습니다

```bash
# 커널 목록 확인
jupyter kernelspec list

# Scala 커널 재설치
coursier bootstrap \
  -r jitpack \
  -i user \
  -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
  sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
  --sources --default=true \
  -o almond
./almond --install

# Ruby 커널 재설치
gem install iruby
iruby register --force
```

### 포트 충돌

```bash
# 다른 호스트 포트 사용
docker run --rm -it -p 8890:8888 sb-jupyter

# 또는 포트 확인
docker ps
netstat -tuln | grep 8889
```

### 패키지 설치

```bash
# Python 패키지
pip install package-name

# Conda 패키지
conda install package-name

# Ruby gem
gem install gem-name

# Scala 라이브러리 (Notebook에서)
import $ivy.`org.group::artifact:version`
```

### 한글 깨짐

```bash
# 폰트 설치 (이미 fonts-dejavu 포함)
# matplotlib 폰트 캐시 재생성
rm -rf ~/.cache/matplotlib
python -c "import matplotlib.pyplot"
```

### Almond 커널 오류

```bash
# Scala 버전 확인
scala -version

# Coursier 재설치
curl -fLo coursier https://git.io/coursier-cli
chmod +x coursier
```

## 고급 사용법

### 1. SDKMAN 사용

```bash
# 컨테이너 내부에서
sdk list java
sdk install java 11.0.12-open
sdk use java 11.0.12-open

sdk list scala
sdk install scala 2.13.6
```

### 2. Facets 확장 사용

```python
# Facets는 이미 설치됨
from IPython.core.display import display, HTML

# Facets Overview 사용
# https://github.com/PAIR-code/facets
```

### 3. JupyterLab 확장

```bash
# 확장 목록
jupyter labextension list

# 확장 설치
jupyter labextension install @jupyterlab/extension-name

# Git 확장
jupyter labextension install @jupyterlab/git
```

### 4. 멀티 Python 환경

```bash
# Python 2 커널 추가 (kernel.py2.json 참조)
conda create -n py27 python=2.7 ipykernel
conda activate py27
ipython kernel install --user --name=python2

# Python 3.6
conda create -n py36 python=3.6 ipykernel
conda activate py36
ipython kernel install --user
```

### 5. 커스텀 Scala 커널

```bash
# kernel.scala.json 수정하여 커스텀 설정
# Scala 버전별로 다른 커널 생성 가능
```

### 6. Docker Compose 사용

```yaml
# docker-compose.yml
version: '3.8'

services:
  jupyter-lab:
    image: sb-jupyter
    build: .
    ports:
      - "8889:8888"
    volumes:
      - ./notebooks:/home/jovyan/work
      - jupyter-kernels:/home/jovyan/.local/share/jupyter/kernels
    environment:
      - JUPYTER_ENABLE_LAB=yes
      - JUPYTER_TOKEN=secret
    command: jupyter lab --ip=0.0.0.0 --port=8888 --allow-root

volumes:
  jupyter-kernels:
```

## 언어별 활용 예제

### Python - 데이터 분석

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# 데이터 로드
df = pd.read_csv('sales.csv')

# 시각화
plt.figure(figsize=(12, 6))
sns.barplot(data=df, x='month', y='sales')
plt.title('Monthly Sales')
plt.show()
```

### Scala - 함수형 프로그래밍

```scala
// List 처리
val numbers = List(1, 2, 3, 4, 5)
val squared = numbers.map(x => x * x)
val evens = numbers.filter(_ % 2 == 0)

// Case class와 패턴 매칭
case class Person(name: String, age: Int)
val alice = Person("Alice", 30)

alice match {
  case Person(n, a) if a >= 18 => println(s"$n is adult")
  case _ => println("Minor")
}
```

### Ruby - 텍스트 처리

```ruby
# 문자열 처리
text = "Hello, Jupyter Lab!"
words = text.split

# 파일 읽기
File.readlines('data.txt').each do |line|
  puts line.strip
end

# JSON 처리
require 'json'
data = { users: ['Alice', 'Bob'] }
puts JSON.pretty_generate(data)
```

### R - 통계 분석

```r
# 선형 회귀
data <- data.frame(
  x = c(1, 2, 3, 4, 5),
  y = c(2, 4, 5, 4, 5)
)

model <- lm(y ~ x, data=data)
summary(model)

# 예측
predict(model, newdata=data.frame(x=6))
```

## 통합 워크플로우

### 1. Python으로 데이터 전처리

```python
import pandas as pd

# 데이터 전처리
df = pd.read_csv('raw_data.csv')
df_clean = df.dropna()
df_clean.to_csv('clean_data.csv', index=False)
```

### 2. Scala로 병렬 처리

```scala
import $ivy.`org.apache.spark::spark-sql:3.1.2`
import org.apache.spark.sql.SparkSession

val spark = SparkSession.builder()
  .appName("DataProcessing")
  .master("local[*]")
  .getOrCreate()

val df = spark.read.csv("clean_data.csv")
df.show()
```

### 3. R로 통계 분석

```r
data <- read.csv('clean_data.csv')
model <- lm(y ~ x1 + x2, data=data)
summary(model)
```

### 4. Ruby로 리포트 생성

```ruby
require 'json'

results = {
  mean: 42.5,
  median: 40.0,
  std: 12.3
}

File.write('report.json', JSON.pretty_generate(results))
```

## 참고 자료

### Jupyter

- [JupyterLab 공식 문서](https://jupyterlab.readthedocs.io/)
- [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)
- [Jupyter 확장](https://github.com/ipython-contrib/jupyter_contrib_nbextensions)

### 언어 커널

- [Almond (Scala)](https://almond.sh/)
- [IRuby](https://github.com/SciRuby/iruby)
- [IRKernel (R)](https://github.com/IRkernel/IRkernel)
- [BeakerX (JVM)](http://beakerx.com/)
- [Coursier](https://get-coursier.io/)

### 참고 링크

- [다중 Python 커널](https://www.44bits.io/ko/post/understanding-jupyter-multiple-kernel-using-python2-and-python3-kernel)
- [Spylon Kernel](https://github.com/Valassis-Digital-Media/spylon-kernel)
- [Clojupyter](https://github.com/clojupyter/clojupyter)

## 관련 프로젝트

- [jupyter](../jupyter/README.md) - Jupyter Notebook Full Stack
- [devpi](../devpi/README.md) - Python 패키지 서버
- [ruby-dev](../ruby-dev/README.md) - Ruby 개발 환경

## 베이스 이미지

- jupyter/minimal-notebook

## 라이선스

Jupyter 프로젝트는 BSD 라이선스를 따릅니다.
