# Inherit from image: https://github.com/Borda/docker_python-opencv-ffmpeg
# FROM borda/docker_python-opencv-ffmpeg:py36-cuda
FROM nvidia/cuda:10.1-cudnn8-devel-ubuntu18.04

# For the next steps thanks to http://www.science.smith.edu/dftwiki/index.php/Tutorial:_Docker_Anaconda_Python_--_4
# Updating Ubuntu packages
# RUN apt-get update && yes | apt-get upgrade
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    unzip \
    nano \
    vim \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    gcc \
    g++ \
    autotools-dev \
    cmake


# Add user ubuntu with no password, add to sudo group
RUN adduser --disabled-password --gecos '' ubuntu \
    && adduser ubuntu sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/
RUN chmod a+rwx /home/ubuntu/

# Anaconda installation
RUN wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh \
    && bash Anaconda3-2019.10-Linux-x86_64.sh -b \
    && rm Anaconda3-2019.10-Linux-x86_64.sh

# Set path to conda
ENV PATH /home/ubuntu/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda -y \
    && conda update anaconda -y \
    && conda update --all -y

# Install general (more lightweight) packages
    # XGBoost
RUN conda install -c conda-forge xgboost -y \
    # CatBoost
    && conda install -c anaconda graphviz && conda config --add channels conda-forge && conda install catboost \
    # Plotly
    && conda install -c plotly plotly -y \
    # Colorlover
    && conda install -c conda-forge colorlover -y \
    # OpenAI Gym
    && pip install gym --user

# Install more heavy packages separately
RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
RUN pip install tensorflow-gpu
RUN conda install -c conda-forge/label/gcc7 opencv

# Configuring access to Jupyter
ARG password
RUN mkdir /home/ubuntu/workspace \
    && jupyter notebook --generate-config --allow-root \
    && echo "c.NotebookApp.password = u\"$(python3 -c "from IPython.lib import passwd; print(passwd(\"${password}\"));")\"" >> /home/ubuntu/.jupyter/jupyter_notebook_config.py


# Jupyter listens port: 8888
EXPOSE 8888

# Run Jupytewr notebook as Docker main process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/workspace", "--ip='*'", "--port=8888", "--no-browser"]
