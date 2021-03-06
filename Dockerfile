FROM jupyter/scipy-notebook

MAINTAINER Project Jupyter <jupyter@googlegroups.com>

# Install Maud and dependencies

RUN python -m pip install --upgrade pip

RUN pip install https://github.com/biosustain/Maud/archive/master.zip

# Install cmdstan

USER root

RUN apt-get update && apt-get install -y wget make g++

RUN mkdir /usr/bin/cmdstan

RUN cd /usr/bin/cmdstan && wget -c https://github.com/rok-cesnovar/cmdstan/releases/download/adjoint_ODE_v2/cmdstan-ode-adjoint-v2.tar.gz -O - | tar -xz

ENV CMDSTAN="/usr/bin/cmdstan/cmdstan-ode-adjoint-v2"

RUN cd $CMDSTAN && make build

# Update permissions
RUN chown -R jovyan:users /home/jovyan/
RUN chmod -R 777 $CMDSTAN

USER jovyan

# Define entrypoint

RUN /bin/bash /usr/local/bin/start-singleuser.sh -h
CMD ["/bin/bash", "/usr/local/bin/start-singleuser.sh"]
