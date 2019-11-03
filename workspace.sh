#!/bin/bash

function show_help()
{
    printf "\nMachine Learning and Computer Vision dockerized workspace. Usage:\n\n"

    printf "./workspace.sh run\n"
    printf "Runs workspace Docker container.\n\n"
    printf "./workspace.sh build\n"
    printf "Builds workspace Docker image. Asks password for Jupyter before building the image.\nParameters:\n\n"
    printf "    --default-psw   Suppresses password entering step by setting it to default value 'root'.\n\n\n"
    printf "\n"
}

case "$1" in

    "run" )
        directory=$HOME/ml_cv_workspace
        if [ ! -d "$directory" ]; then
            mkdir $directory
        fi
        docker run --rm -p 8888:8888 -v $directory:/home/ubuntu/workspace ml_cv_dockerized_workspace
        ;;

    "build" )
        password="root"
        if [[ "$2" != "--default-psw" ]]; then
            echo -n "Set the password for Jupyter notebook server: "
            read -s password
            echo
        fi
        docker build -t ml_cv_dockerized_workspace --build-arg password=$password .
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