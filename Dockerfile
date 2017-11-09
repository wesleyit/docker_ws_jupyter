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
		h5py bash_kernel imageio pillow

## The same with pip3
RUN pip3 install jupyter jupyter-contrib-nbextensions requests \
    docutils numpy scipy pandas matplotlib seaborn jupyter-tensorboard \
    graphviz statsmodels scikit-learn tensorflow Keras mxnet tflearn \
		h5py bash_kernel imageio pillow

## Install R-lang for statistics computation
RUN apt install r-base libcurl4-openssl-dev libssl-dev -y

## Configure the locales to UTF-8
RUN apt install locales -y && \
		echo 'LC_ALL=en_US.UTF-8' > /etc/default/locale && \
		locale-gen en_US.UTF-8 && \
		dpkg-reconfigure -f noninteractive locales && \
		localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Create an unprivileged user
RUN useradd -m jupyter -s /bin/bash
WORKDIR /home/jupyter/

## Add Elixir support and  Compile the kernel as a limited user
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
		dpkg -i erlang-solutions_1.0_all.deb && \
		rm -rf erlang-solutions_1.0_all.deb && \
		apt update && \
		apt install esl-erlang elixir -y
RUN git clone https://github.com/pprzetacznik/IElixir.git /opt/ielixir && \
		chown -R 1000:1000 /opt/ielixir
USER jupyter
RUN cd /opt/ielixir && \
		mix local.hex --force && \
		mix local.rebar --force && \
		export PATH=$HOME/.mix:$PATH && \
		mix deps.get && \
		mix test && \
		MIX_ENV=prod mix compile && \
		./install_script.sh
USER root

## Compile and add the R Kernel to Jupyter
RUN curl https://gist.githubusercontent.com/wesleyit/58f52659bfef73ea7836bb44d64af389/raw/bda2089637252ceb10b338d09a589ff2848bf2ed/install_iR_to_jupyter.sh | bash 
RUN chown -R jupyter. /usr/local/lib/R

## Add a script to enable extensions and start jupyter
COPY start_jupyter.sh /usr/local/bin/start_jupyter.sh

## Add a directory with some files and share it via volume
RUN mkdir /home/jupyter/notebooks
COPY jupyter_notebook_config.py /home/jupyter/jupyter_notebook_config.py
COPY notebooks /home/jupyter/notebooks
COPY kernels /home/jupyter/kernels

## Creating the kernels
RUN mv /home/jupyter/.local/share/jupyter/ /tmp/j
RUN mkdir -p /home/jupyter/.local/share/jupyter/
RUN ln -s /home/jupyter/kernels /home/jupyter/.local/share/jupyter/
RUN cp -r /tmp/j/kernels/* /home/jupyter/.local/share/jupyter/kernels/ && rm -rf /tmp/j

## Expose the default jupyter port
EXPOSE 8888

## Start jupyter notebook using the script and the created user
RUN chown -vR 1000:1000 /home/jupyter
VOLUME /home/jupyter/notebooks
USER jupyter
ENV PATH="/home/jupyter/.mix:${PATH}"
CMD ["bash", "/usr/local/bin/start_jupyter.sh"]

