# docker-jupyter

docker image for jupyter lab(languages)

## languages

https://www.44bits.io/ko/post/understanding-jupyter-multiple-kernel-using-python2-and-python3-kernel
https://github.com/jupyter/docker-stacks

* jvm(groovy, scala, kotlin, clojure)
    <http://beakerx.com/>
    <https://github.com/clojupyter/clojupyter>
* scala
    <https://get-coursier.io/>
    <https://github.com/almond-sh/almond>
    <https://almond.sh/docs/install-multiple>
    <https://github.com/Valassis-Digital-Media/spylon-kernel>
* julia
* python2
* python3
* r
    <https://github.com/IRkernel/IRkernel>
    <https://github.com/jupyter/docker-stacks/tree/master/r-notebook>
* go
* c++
* ruby
    <https://github.com/SciRuby/iruby>

## RUN

docker build . -t sb-jupyter
docker build . --no-cache -t sb-jupyter
docker run --rm -it -p 8888:8888 sb-jupyter bash
jupyter kernelspec list
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root

docker run -it --rm -p 8888:8888 -e GRANT_SUDO=yes --user root gcr.io/kubeflow-images-staging/tensorflow-notebook-cpu
docker run -it --rm -p 8888:8888 -e GRANT_SUDO=yes --user root jupyter/minimal-notebook
base-notebook


https://stackoverflow.com/questions/30492623/using-both-python-2-x-and-python-3-x-in-ipython-notebook
conda create -n py27 python=2.7 ipykernel
conda create -n py36 python=3.6 ipykernel

conda create -n py27 python=2.7
conda activate py27
conda install notebook ipykernel
ipython kernel install --user

conda create -n py36 python=3.6
conda activate py36
conda install notebook ipykernel
ipython kernel install --user


https://ndres.me/post/best-jupyter-notebook-extensions/
https://github.com/ipython-contrib/jupyter_contrib_nbextensions

https://zzsza.github.io/development/2018/08/15/jupyter-notebook-in-jekyll/
