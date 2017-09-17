Jupyter - iPython Notebooks
===========================

Hi! I am a Linux user studying statistics and data science.

I just finished a Big Data course and I am in love with Jupyter.

It is a wonderful piece of software, very easy to use and very powerful.

It is like a web interface to iPython, but you can use it to program
in other languages like R, Julia, Elixir, Bash and Ruby.

We will focus on Python2 and Python 3, but feel free to explore
and expand your Jupyter Container, take a look at my github.

![](http://jupyter.org/assets/jupyterpreview.png)

![](http://i.imgur.com/eo2SqS9.png)


Requirements
------------

You will need to have `curl`, `docker` and `git` installed.
I tried to run this installer only on Linux, but I think it 
should work on Mac and Windows without too much effort.


 Install
-------

Execute the installer pasting the following line on your terminal:

```
curl https://raw.githubusercontent.com/wesleyit/docker_ws_jupyter/master/installer.sh | bash
```

It will create the `Jupyter` folder on your home dir.
Inside this folder you will find two things:
 
 - the `notebooks` folder, in which your files are saved.
 - the `init_jupyter_container.sh` script, which you will use to start the container.

To start the container:

```
$ cd Jupyter
./init_jupyter_container.sh
```

Then, open your browser on `http://localhost:8888`.

Thanks for using :)
