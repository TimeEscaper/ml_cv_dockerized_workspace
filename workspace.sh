#!/bin/bash

case "$1" in
    "run" )
        directory=$HOME/ml_cv_workspace
        echo $directory
        if [ ! -d "$directory" ]; then
            mkdir $directory
        fi
        docker run --rm -p 8888:8888 -v $directory:/home/ubuntu/workspace ml_cv_dockerized_workspace
        ;;
    "build" )
        docker build -t ml_cv_dockerized_workspace .
        ;;
esac