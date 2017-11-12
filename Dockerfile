## Migrating from Debian to Ubuntu because there are
# many tools (i.e. GO) that have official support
# and updated repositories for Ubuntu.
FROM ubuntu:17.10

## The "MAINTAINER" tag is deprecated :)
LABEL maintainer="Wesley Rodrigues da Silva <wesley.it@gmail.com>"

## Refreshing the apt package list and updating the system.
RUN apt update && apt upgrade -y

## Installing very basic packages.
WORKDIR /root
ADD ./packages-base.txt /root
RUN apt install -y $(cat packages-base.txt)

## Configuring the locales and language settings to UTF-8.
RUN echo 'LC_ALL=en_US.UTF-8' > /etc/default/locale && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure -f noninteractive locales && \
    localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Creating an unprivileged user.
RUN useradd -m jupyter -s /bin/bash -d /home/jupyter

## Installing Python2 and Python3 globally.
ADD ./packages-python.txt /root
RUN apt install -y $(cat packages-python.txt)

## Installing the Python packages via PIP (for Pythons 2 and 3).
ADD ./requirements.txt /root
RUN pip2 install -r requirements.txt
RUN pip3 install -r requirements.txt

## Installing the R Language globally.
ADD ./packages-r.txt /root
RUN apt install -y $(cat packages-r.txt)
RUN chown -R 1000:1000 /usr/local/lib/R

## Installing GO Language globally.
RUN add-apt-repository ppa:gophers/archive && apt update
ADD ./packages-go.txt /root
RUN apt install -y $(cat packages-go.txt)

## Installing Elixir and Erlang Languages globally.
ADD ./packages-elixir.txt /root
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb && \
    rm -rf erlang-solutions_1.0_all.deb
RUN apt update && apt install -y $(cat packages-elixir.txt)

## Configuring the environment using the limited user "jupyter".
USER jupyter
WORKDIR /home/jupyter

## Installing IElixir
ADD setup-elixir.sh /home/jupyter
ENV PATH /home/jupyter/.mix:${PATH}
RUN bash setup-elixir.sh

## Configuring GO for the limited user.
ENV GOROOT /usr/lib/go-1.9
ENV GOPATH /home/jupyter/.go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}

## Installing the GO Notebook package.
ADD setup-go.sh /home/jupyter
RUN bash setup-go.sh

## Installing and configuring the R Notebook package.
ADD setup-r.sh /home/jupyter
RUN bash setup-r.sh

## Adding a script to enable extensions and start jupyter.
ADD start_jupyter.sh /usr/local/bin/start_jupyter.sh

## Adding a directory with some files and share it via volume
RUN mkdir /home/jupyter/notebooks
ADD jupyter_notebook_config.py /home/jupyter/jupyter_notebook_config.py
ADD notebooks /home/jupyter/notebooks
ADD kernels /home/jupyter/kernels

## Fixing all permissions and exporting the volume
USER root
RUN chown -R 1000:1000 /home/jupyter
VOLUME /home/jupyter/notebooks
USER jupyter

## Creating the kernels
RUN mv /home/jupyter/.local/share/jupyter/ /tmp/j
RUN mkdir -p /home/jupyter/.local/share/jupyter/
RUN ln -s /home/jupyter/kernels /home/jupyter/.local/share/jupyter/
RUN cp -r /tmp/j/kernels/* /home/jupyter/.local/share/jupyter/kernels/ && \
    rm -rf /tmp/j

## Exposing the default jupyter port
EXPOSE 8888

## Starting jupyter notebook using the script and the created user.
CMD ["bash", "/usr/local/bin/start_jupyter.sh"]
