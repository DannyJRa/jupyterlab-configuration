#From Scratch
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y build-essential  \
     checkinstall \
     libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    zlib1g-dev \
    openssl \
    libffi-dev \
    python3-dev \
    python3-setuptools \
    wget

RUN mkdir /tmp/Python37 \
    && cd /tmp/Python37 \
    && wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz \
    && tar xvf Python-3.7.0.tar.xz \
    && cd /tmp/Python37/Python-3.7.0 \
    && ./configure \
    && make altinstall

RUN ln -s /usr/local/bin/python3.7 /usr/bin/python
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py

RUN pip install --upgrade pip
RUN pip install requests
RUN apt-get install curl -y

RUN pip install jupyter --upgrade
RUN pip install jupyterlab --upgrade

RUN apt-get install pandoc -y
RUN apt-get install texlive-xetex -y 

RUN unlink /usr/bin/python
RUN ln -s /usr/local/bin/python3.7 /usr/bin/python

RUN apt-get install bash -y
RUN pip install bash_kernel
RUN python -m bash_kernel.install

# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

#Install DS packages

RUN conda install -c anaconda numpy
RUN conda install -c anaconda scipy
RUN apt-get install liblzma-dev
RUN conda install -c conda-forge wordcloud -y
RUN conda install -c anaconda pandas
RUN conda install -c anaconda scikit-learn

ENV MAIN_PATH=/usr/local/bin/jpl_config
ENV LIBS_PATH=${MAIN_PATH}/libs
ENV CONFIG_PATH=${MAIN_PATH}/config
ENV NOTEBOOK_PATH=${MAIN_PATH}/notebooks

#Added extenions
# https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile
# Install Python 3 packages
RUN conda install --quiet --yes \
    'beautifulsoup4=4.8.*' \
    && \
    #conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    #jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    conda install -c conda-forge nodejs && \

    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install @lckr/jupyterlab_variableinspector --no-build && \
    jupyter labextension install jupyterlab-drawio --no-build && \
    jupyter lab build --dev-build=False

 


EXPOSE 8888

CMD cd ${MAIN_PATH} && sh config/run_jupyter.sh
