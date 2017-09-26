## Use Debian as base image
FROM wesleyit/ws-debian-base:stretch

## Upgrade before install
RUN apt update && apt upgrade -y

## Install the base development stack for python 2 and 3
RUN apt install python3-dev python3-pip python3-virtualenv \
    python-dev python-pip python-virtualenv -y

## Install a rich set of libs for analysis using pip
RUN pip install jupyter jupyter-contrib-nbextensions requests \
    docutils numpy scipy pandas matplotlib seaborn jupyter-tensorboard \
    graphviz statsmodels scikit-learn tensorflow Keras mxnet tflearn \
		h5py

## The same with pip3
RUN pip3 install jupyter jupyter-contrib-nbextensions requests \
    docutils numpy scipy pandas matplotlib seaborn jupyter-tensorboard \
    graphviz statsmodels scikit-learn tensorflow Keras mxnet tflearn \
		h5py 

## Add a script to enable extensions and start jupyter
COPY start_jupyter.sh /usr/local/bin/start_jupyter.sh

## Create an unprivileged user
RUN useradd -m jupyter -s /bin/bash
WORKDIR /home/jupyter/

## Add a directory with some files and share it via volume
RUN mkdir /home/jupyter/notebooks
COPY jupyter_notebook_config.py /home/jupyter/jupyter_notebook_config.py
COPY notebooks /home/jupyter/notebooks
COPY kernels /home/jupyter/kernels

## Creating the kernels
RUN mkdir -p /home/jupyter/.local/share/jupyter/
RUN ln -s /home/jupyter/kernels /home/jupyter/.local/share/jupyter/

## Expose the default jupyter port
EXPOSE 8888

## Start jupyter notebook using the script and the created user
RUN chown -vR 1000:1000 /home/jupyter
VOLUME /home/jupyter/notebooks
USER jupyter
CMD ["bash", "/usr/local/bin/start_jupyter.sh"]
