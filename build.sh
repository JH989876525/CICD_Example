#!/bin/bash
# Copyright (c) 2024 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

MODE=${1}
VERSION="latest"
IMAGE_NAME="ppes-rtsp"
HOST_TYPE=$(uname -m)

function run_docker {
    docker run --net=host -d \
    "bluenviron/mediamtx:${VERSION}"
}

function build_docker_image {
    if [ "${HOST_TYPE}" == "aarch64" ]
    then
        docker build -t "bluenviron/mediamtx:${VERSION}" .
        docker save -o "${IMAGE_NAME}.tar" "bluenviron/mediamtx:${VERSION}"
    else
        docker buildx build --platform linux/arm64 \
            --output type=docker \
            -t "bluenviron/mediamtx:${VERSION}" .
    fi
    chmod 666 "${IMAGE_NAME}.tar"
}

function save_docker_image {
    docker save -o "${IMAGE_NAME}.tar" "bluenviron/mediamtx:${VERSION}"
    chmod 666 "${IMAGE_NAME}.tar"
}

function build_rpm {
    rpmbuild -bb --target aarch64 rpm/ppes-rtsp.spec
}

function remove_all {
    rm ./*.tar
    rm -rf rpm/aarch64
}

case ${MODE} in
	all)
        remove_all
        build_docker_image
        build_rpm
    ;;
    image)
        remove_all
        build_docker_image
    ;;
    run)
        run_docker
    ;;
	*)  
        echo "${0} <MODE>"
        echo "    MODE : all, image"
    ;;
esac