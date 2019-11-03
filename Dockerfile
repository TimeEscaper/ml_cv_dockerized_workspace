# Inherit from image: https://github.com/Borda/docker_python-opencv-ffmpeg
FROM borda/docker_python-opencv-ffmpeg

# For the next steps thanks to http://www.science.smith.edu/dftwiki/index.php/Tutorial:_Docker_Anaconda_Python_--_4
# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade
RUN apt-get install -y emacs

# Adding wget and bzip2
RUN apt-get install -y wget bzip2 ca-certificates

# Add sudo
RUN apt-get -y install sudo

# Add user ubuntu with no password, add to sudo group
RUN adduser --disabled-password --gecos '' ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/
RUN chmod a+rwx /home/ubuntu/
#RUN echo `pwd`

# Anaconda installing
RUN wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
RUN bash Anaconda3-2019.10-Linux-x86_64.sh -b
RUN rm Anaconda3-2019.10-Linux-x86_64.sh

# Set path to conda
#ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/ubuntu/anaconda3/bin:$PATH

# Updating Anaconda packages
# TODO: Fix
RUN conda update conda -y
#RUN conda update anaconda -y
RUN conda update --all -y

# Install additional packages

# XGBoost
RUN conda install -c conda-forge xgboost -y

# CatBoost
RUN conda config --add channels conda-forge
RUN conda install catboost

# CVXPY
RUN conda install -c conda-forge lapack -y
RUN conda install -c cvxgrp cvxpy -y


# Configuring access to Jupyter
RUN mkdir /home/ubuntu/workspace
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /home/ubuntu/.jupyter/jupyter_notebook_config.py

# Jupyter listens port: 8888
EXPOSE 8888

# Run Jupytewr notebook as Docker main process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/workspace", "--ip='*'", "--port=8888", "--no-browser"]

