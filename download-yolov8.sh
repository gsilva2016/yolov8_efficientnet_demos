#!/bin/bash

echo "Creating OpenVINO INT8 Quantized Yolov8 IR"
#buildargs="--build-arg REFRESH_OPTION=--refresh"
sudo docker build -t openvino_yolov8-download:1.1 $buildargs -f Dockerfile.yolov8-download .

echo "Saving IR files to yolov8_ensemble/models/yolov8/1/"
sudo docker run --rm -it -v `pwd`/yolov8_ensemble/models/yolov8/1/:/savedir openvino_yolov8-download:1.1

ls -l yolov8_ensemble/models/yolov8/1
