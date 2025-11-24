ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

ARG SCALA_11_VERSION=2.11.12
ARG SCALA_12_VERSION=2.12.8
ARG SCALA_13_VERSION=2.13.0

ENV SCALA_11_VERSION=$SCALA_11_VERSION
ENV SCALA_12_VERSION=$SCALA_12_VERSION
ENV SCALA_13_VERSION=$SCALA_13_VERSION

ENV ALMOND_VERSION=0.6.0
ENV JAVA_VERSION=12
ENV RUBY_VERSION=2.6.4

EXPOSE 8888
USER root

# ARG REPO_ADDR=http://mirror.kakao.com

RUN sed -i 's@http://archive.ubuntu.com/@http://mirror.kakao.com/@g' /etc/apt/sources.list &&\
    sed -i 's@http://security.ubuntu.com/@http://mirror.kakao.com/@g' /etc/apt/sources.list &&\
    apt-get update -qq && apt-get -y upgrade &&\
    apt-get -y install sudo tree vim build-essential git zip unzip curl fonts-dejavu \
    ffmpeg gfortran gcc unixodbc unixodbc-dev r-cran-rodbc &&\
    rm -rf /var/lib/apt/lists/*


# ======================= start ===========================

# ---------- SciPy

# USER root

# # ffmpeg for matplotlib anim
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends ffmpeg && \
#     rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install Python 3 packages
RUN conda install --quiet --yes \
    'beautifulsoup4=4.8.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=1.3*' \
    'cloudpickle=1.2*' \
    'cython=0.29*' \
    'dask=2.2.*' \
    'dill=0.3*' \
    'h5py=2.9*' \
    'hdf5=1.10*' \
    'ipywidgets=7.5*' \
    'matplotlib-base=3.1.*' \
    'numba=0.45*' \
    'numexpr=2.6*' \
    'pandas=0.25*' \
    'patsy=0.5*' \
    'protobuf=3.9.*' \
    'scikit-image=0.15*' \
    'scikit-learn=0.21*' \
    'scipy=1.3*' \
    'seaborn=0.9*' \
    'sqlalchemy=1.3*' \
    'statsmodels=0.10*' \
    'sympy=1.4*' \
    'vincent=0.4.*' \
    'xlrd' \
    && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^1.0.1 --no-build && \
    jupyter labextension install jupyterlab_bokeh@1.0.0 --no-build && \
    jupyter lab build --dev-build=False && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER $NB_UID

# ---------- TensorFlow from SciPy

# Install Tensorflow
RUN conda install --quiet --yes \
    'tensorflow=1.13*' \
    'keras=2.2*' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# ---------- DataScience from SciPy

# Set when building on Travis so that certain long-running build steps can
# be skipped to shorten build time.
ARG TEST_ONLY_BUILD

USER root

# # R pre-requisites
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     fonts-dejavu \
#     gfortran \
#     gcc && \
#     rm -rf /var/lib/apt/lists/*

# Julia dependencies
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.2.0

RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "926ced5dec5d726ed0d2919e849ff084a320882fb67ab048385849f9483afc47 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

# Show Julia where conda libraries are \
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir $JULIA_PKGDIR && \
    chown $NB_USER $JULIA_PKGDIR && \
    fix-permissions $JULIA_PKGDIR

USER $NB_UID

# R packages including IRKernel which gets installed globally.
RUN conda install --quiet --yes \
    'r-base=3.6.1' \
    'r-caret=6.0*' \
    'r-crayon=1.3*' \
    'r-devtools=2.1*' \
    'r-forecast=8.7*' \
    'r-hexbin=1.27*' \
    'r-htmltools=0.3*' \
    'r-htmlwidgets=1.3*' \
    'r-irkernel=1.0*' \
    'r-nycflights13=1.0*' \
    'r-plyr=1.8*' \
    'r-randomforest=4.6*' \
    'r-rcurl=1.95*' \
    'r-reshape2=1.4*' \
    'r-rmarkdown=1.14*' \
    'r-rsqlite=2.1*' \
    'r-shiny=1.3*' \
    'r-sparklyr=1.0*' \
    'r-tidyverse=1.2*' \
    'rpy2=2.9*' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Add Julia packages. Only add HDF5 if this is not a test-only build since
# it takes roughly half the entire build time of all of the images on Travis
# to add this one package and often causes Travis to timeout.
#
# Install IJulia as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'import Pkg; Pkg.update()' && \
    (test $TEST_ONLY_BUILD || julia -e 'import Pkg; Pkg.add("HDF5")') && \
    julia -e "using Pkg; pkg\"add IJulia\"; pkg\"precompile\"" && \ 
    # move kernelspec out of home \
    mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter


# ---------- PySpark from SciPy

USER root

# Spark dependencies
ENV APACHE_SPARK_VERSION 2.4.4
ENV HADOOP_VERSION 2.7

# RUN apt-get -y update && \
#     apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
#     rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    wget -q http://mirrors.ukfast.co.uk/sites/ftp.apache.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    echo "2E3A5C853B9F28C7D4525C0ADCB0D971B73AD47D5CCE138C85335B9F53A6519540D3923CB0B5CEE41E386E49AE8A409A51AB7194BA11A254E037A848D0C4A9E5 *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local --owner root --group root --no-same-owner && \
    rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

# # Mesos dependencies
# # Install from the Xenial Mesosphere repository since there does not (yet)
# # exist a Bionic repository and the dependencies seem to be compatible for now.
# COPY mesos.key /tmp/
# RUN apt-get -y update && \
#     apt-get install --no-install-recommends -y gnupg && \
#     apt-key add /tmp/mesos.key && \
#     echo "deb http://repos.mesosphere.io/ubuntu bionic main" > /etc/apt/sources.list.d/mesosphere.list && \
#     apt-get -y update && \
#     # apt-get --no-install-recommends -y install mesos=1.2\* && \
#     apt-get --no-install-recommends -y install marathon && \
#     apt-get purge --auto-remove -y gnupg && \
#     rm -rf /var/lib/apt/lists/*

# USER $NB_UID
# RUN conda install --quiet --yes \
#     'virtualenv' \
#     && \
#     conda clean --all -f -y && \
#     fix-permissions $CONDA_DIR && \
#     fix-permissions /home/$NB_USER
# # build-essential python-dev python-six python-virtualenv libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev zlib1g-dev iputils-ping

# # USER root
# RUN wget http://www.apache.org/dist/mesos/1.8.0/mesos-1.8.0.tar.gz &&\
#     tar -zxf mesos-1.8.0.tar.gz &&\
#     apt-get install -y autoconf libtool &&\
#     build-essential libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev zlib1g-dev iputils-ping &&\
#     cd mesos-1.8.0 &&\
#     ./bootstrap &&\
#     mkdir build &&\
#     cd build &&\
#     ../configure &&\
#     make


# Spark and Mesos config
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip
ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

USER $NB_UID

# Install pyarrow
# RUN conda install --quiet -y 'pyarrow=0.13.0*' && \
RUN conda install --quiet -y 'pyarrow' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# ---------- All Spark from PySpark

USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# # R pre-requisites
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     fonts-dejavu \
#     gfortran \
#     gcc && \
#     rm -rf /var/lib/apt/lists/*

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=3.6.1' \
    'r-ggplot2=3.2*' \
    'r-irkernel=1.0*' \
    'r-rcurl=1.95*' \
    'r-sparklyr=1.0*' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Apache Toree kernel
RUN pip install --no-cache-dir \
    https://dist.apache.org/repos/dist/release/incubator/toree/0.3.0-incubating/toree-pip/toree-0.3.0.tar.gz \
    && \
    jupyter toree install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Spylon-kernel
RUN conda install --quiet --yes 'spylon-kernel=0.4*' && \
    conda clean --all -f -y && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# ---------- R from Minimal

USER root

# # R pre-requisites
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     fonts-dejavu \
#     unixodbc \
#     unixodbc-dev \
#     r-cran-rodbc \
#     gfortran \
#     gcc && \
#     rm -rf /var/lib/apt/lists/*

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=3.6.1' \
    'r-caret=6.0*' \
    'r-crayon=1.3*' \
    'r-devtools=2.0*' \
    'r-forecast=8.7*' \
    'r-hexbin=1.27*' \
    'r-htmltools=0.3*' \
    'r-htmlwidgets=1.3*' \
    'r-irkernel=1.0*' \
    'r-nycflights13=1.0*' \
    'r-plyr=1.8*' \
    'r-randomforest=4.6*' \
    'r-rcurl=1.95*' \
    'r-reshape2=1.4*' \
    'r-rmarkdown=1.14*' \
    'r-rodbc=1.3*' \
    'r-rsqlite=2.1*' \
    'r-shiny=1.3*' \
    'r-sparklyr=1.0*' \
    'r-tidyverse=1.2*' \
    'unixodbc=2.3.*' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR

# Install e1071 R package (dependency of the caret R package)
RUN conda install --quiet --yes r-e1071

# ======================= end ===========================

USER $NB_UID

# conda update conda
# conda update --all
RUN conda install --quiet --yes \
    'jupyter' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR &&\
    fix-permissions /home/$NB_USER


# JVM
RUN curl -s "https://get.sdkman.io" | bash
ADD sdkman.config $HOME/.sdkman/etc/config
RUN /bin/bash -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\" &&\
    sdk i java 12.0.2-zulu &&\
    sdk i gradle &&\
    sdk i maven &&\
    sdk i scala ${SCALA_11_VERSION} &&\
    sdk i scala ${SCALA_13_VERSION} &&\
    sdk i scala ${SCALA_12_VERSION} &&\
    sdk i sbt &&\
    sdk i kotlin &&\
    sdk i kscript &&\
    sdk i groovy &&\
    sdk i leiningen &&\
    sdk i ceylon"


# SCALA
RUN mkdir -p $HOME/bin

RUN /bin/bash -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\" &&\
    curl -Lo $HOME/bin/coursier https://git.io/coursier-cli &&\
    chmod +x $HOME/bin/coursier &&\
    $HOME/bin/coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_11_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_11_VERSION:$ALMOND_VERSION \
    --sources --default=true \
    -o almond &&\
    ./almond --install --install --id scala211 --display-name \"Scala (2.11)\" &&\
    rm -f almond"

RUN /bin/bash -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\" &&\
    curl -Lo $HOME/bin/coursier https://git.io/coursier-cli &&\
    chmod +x $HOME/bin/coursier &&\
    $HOME/bin/coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_12_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_12_VERSION:$ALMOND_VERSION \
    --sources --default=true \
    -o almond &&\
    ./almond --install --install --id scala212 --display-name \"Scala (2.12)\" &&\
    rm -f almond"

RUN /bin/bash -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\" &&\
    curl -Lo $HOME/bin/coursier https://git.io/coursier-cli &&\
    chmod +x $HOME/bin/coursier &&\
    $HOME/bin/coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_13_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_13_VERSION:$ALMOND_VERSION \
    --sources --default=true \
    -o almond &&\
    ./almond --install --install --id scala213 --display-name \"Scala (2.13)\" &&\
    rm -f almond"

# USER $NB_UID
# RUN ipython console --kernel scala211


# RUBY
USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ruby-dev libtool libtool-bin autoconf autogen libltdl-dev libffi-dev make libzmq3-dev libczmq-dev libssl-dev libreadline-dev zlib1g-dev ruby-ffi-rzmq
    # gcc-8 clang-7

USER $NB_UID

RUN git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv &&\
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc &&\
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc &&\
    mkdir -p $HOME/.rbenv/plugins  &&\
    git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
ENV PATH $HOME/.rbenv/bin:$PATH
RUN eval "$(rbenv init -)" &&\
    rbenv install 2.6.4 &&\
    rbenv global 2.6.4 &&\
    gem install iruby cztop ffi-rzmq &&\
    iruby register --force

# RUN gem install pry pry-doc awesome_print gnuplot rubyvis nyaplot cztop rbczmq &&\
#     yard config --gem-install-yri

# Clojure
RUN conda install -y -c simplect clojupyter
RUN conda install -y -c conda-forge ipywidgets beakerx

# ===================== clean

USER root
RUN rm -rf /var/lib/apt/lists/* &&\
    conda clean --all -f -y &&\
    fix-permissions $CONDA_DIR &&\
    fix-permissions /home/$NB_USER
USER $NB_UID
CMD ["jupyter", "notebook"]