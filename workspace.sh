#!/bin/bash

function show_help()
{
    printf "\nMachine Learning and Computer Vision dockerized workspace. Usage:\n\n"

    printf "./workspace.sh run\n"
    printf "Runs workspace Docker container.\n\n"
    printf "./workspace.sh build\n"
    printf "Builds workspace Docker image.\n\n"
    printf "\n"
}

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
    "help" )
        show_help
        exit
        ;;
    * )
        echo "Unknow argument. See help."
        exit
        ;;
esac