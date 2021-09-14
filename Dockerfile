FROM jupyter/scipy-notebook

MAINTAINER Project Jupyter <jupyter@googlegroups.com>

# Install Maud and dependencies

RUN python -m pip install --upgrade pip

RUN pip install https://github.com/biosustain/Maud/archive/master.zip

# Install cmdstan

USER root

RUN apt-get update && apt-get install -y wget make g++

RUN mkdir cmdstan

RUN cd cmdstan && wget -c https://github.com/rok-cesnovar/cmdstan/releases/download/adjoint_ODE_v2/cmdstan-ode-adjoint-v2.tar.gz -O - | tar -xz

ENV CMDSTAN="/home/jovyan/cmdstan/cmdstan-ode-adjoint-v2"

RUN cd $CMDSTAN && make build

# Copy files

COPY . /home/jovyan/work/maud_demo

# Update permissions
RUN chown -R jovyan:users /home/jovyan/

USER jovyan

# Define entrypoint

CMD jupyter notebook
