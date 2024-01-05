#
# Copyright (C) 2023-2024 Intel Corporation.
#
#
# -----------------------------------------------------------

# Add "-devel" for development image
# Remove -dpcpp for not dpcpp image
# For more info refer to: https://hub.docker.com/r/intel/dlstreamer/tags
ARG BASE_IMAGE=intel/dlstreamer:2023.0.0-ubuntu22-gpu682-dpcpp
FROM $BASE_IMAGE as release

USER root
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

WORKDIR /

# Install dependencies
ARG BUILD_DEPENDENCIES="cmake build-essential git-gui python3 python3-pip clang wget curl vim"
RUN apt -y update && \
    apt install -y ${BUILD_DEPENDENCIES} && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Copy Vision-Checkout reference sources
RUN git clone https://github.com/gsilva2016/vision-self-checkout.git
RUN cd vision-self-checkout; git checkout intel-devcloud;

RUN mkdir -p /app/dlstreamer/models
COPY yolo_efficientnet*.sh /app/dlstreamer
RUN cp -R vision-self-checkout/download_models/ /tmp
RUN cd /tmp/download_models/; ./modelDownload.sh --refresh; cp -R /tmp/configs/dlstreamer/models/2022/* /app/dlstreamer/models/

WORKDIR /app/dlstreamer

# Sample videos go here
RUN wget -O ./sample-video.mp4 https://www.pexels.com/video/4465029/download/

ENTRYPOINT ["/bin/bash", "-c"]