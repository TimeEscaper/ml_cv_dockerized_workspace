# Machine Learning and Computer Vision dockerized workspace

Docker image and simple related container managment script that are designed for research and development purposes in the field of Data Science, Machine Learning and Computer Vision.

Initially, the idea of "dockerized workspace" was inspired by the dependencies and configurations mess that I faced while installing OpenCV, ROS and Anaconda together on my host system. This is not the best way to use Docker, but it can be something like "personal workaround" for that mess.

---

## Usage

Script [workspace.sh](https://github.com/TimeEscaper/ml_cv_dockerized_workspace/blob/master/workspace.sh) is used to simplify operations with Docker image and container.

To build workspace (Docker image) use command:
```bash
./workspace.sh build
```
Before building an image, script will ask for the password for Jupyter notebook server. To skip this step and use default password *root*, use can use special parameter:
```bash
./workspace.sh build --default-psw
```

To run workspace (Dokcer container), use command:
```bash
./workspace.sh run
```
Directory **~/ml_cv_workspace** will be mounted to the container in read/write mode and used as a notebook directory for Jupyter. You should store notebooks and other filed that you want to work with in this directory.

Jupyter will be accessed at [localhost:8888](http://localhost:8888).