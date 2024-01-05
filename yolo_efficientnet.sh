#!/bin/bash
#
# Copyright (C) 2023 Intel Corporation.
#
# SPDX-License-Identifier: Apache-2.0
#

cid_count=0

# change pre_process="" if using USB or RealSense cameras
pre_process="pre-process-backend=vaapi-surface-sharing pre-process-config=VAAPI_FAST_SCALE_LOAD_FACTOR=1"

# User configured parameters
if [ -z "$INPUT_TYPE" ]
then
	INPUT_TYPE="FILE_H264"
	#INPUT_TYPE="RTSP_H265"
fi

if [ -z "$INPUTSRC" ]
then
	INPUTSRC="sample-video.mp4 "
	#INPUTSRC="rtsp://127.0.0.1:8554/camera_0 "
fi

DET_MODEL="models/yolov5s/1/FP32-INT8/yolov5s.xml"
DET_MODEL_PROC="models/yolov5s/1/yolov5s.json"
RECOG_MODEL="models/efficientnet-b0/1/FP16-INT8/efficientnet-b0.xml"
RECOG_MODEL_PROC="models/efficientnet-b0/1/efficientnet-b0.json"
RECOG_LABELS="models/efficientnet-b0/1/imagenet_2012.txt"

if [ "$INPUT_TYPE" == "FILE_H264" ]
then
	INPUTSRC="filesrc location=$INPUTSRC ! qtdemux ! h264parse "

elif [ "$INPUT_TYPE" == "RTSP_H264" ]
then
	INPUTSRC="$INPUTSRC ! rtph264depay "

elif [ "$INPUT_TYPE" == "FILE_H265" ]
then
	INPUTSRC="filesrc location=$INPUTSRC ! qtdemux ! h265parse "

elif [ "$INPUT_TYPE" == "RTSP_H265" ]
then
	INPUTSRC="$INPUTSRC ! rtph265depay "
fi


if [ "1" == "$LOW_POWER" ]
then
	echo "Enabled GPU based low power pipeline "
	gst-launch-1.0 $INPUTSRC ! vaapidecodebin ! gvadetect model-instance-id=odmodel name=detection model=$DET_MODEL model-proc=$DET_MODEL_PROC threshold=.5 device=GPU $pre_process ! gvaclassify model-instance-id=clasifier labels=$RECOG_LABELS model=$RECOG_MODEL model-proc=$RECOG_MODEL_PROC device=GPU inference-region=roi-list name=classification $pre_process ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/app/dlstreamer/results/r$cid_count.jsonl ! fpsdisplaysink video-sink=fakesink sync=false --verbose 2>&1 | tee >/app/dlstreamer/results/gst-launch_core_$cid_count.log >(stdbuf -oL sed -n -e 's/^.*current: //p' | stdbuf -oL cut -d , -f 1 > /app/dlstreamer/results/pipeline$cid_count.log)
elif [ "$RENDER_MODE" == "1" ]
then
	echo "Launching rendered pipeline"
	gst-launch-1.0 $INPUTSRC ! vaapidecodebin ! gvadetect model-instance-id=odmodel name=detection model=$DET_MODEL model-proc=$DET_MODEL_PROC threshold=.5 device=GPU $pre_process ! gvaclassify model-instance-id=clasifier labels=$RECOG_LABELS model=$RECOG_MODEL model-proc=$RECOG_MODEL_PROC device=GPU inference-region=roi-list name=classification $pre_process ! gvametaconvert name=metaconvert add-empty-results=true ! vaapipostproc ! gvawatermark ! videoconvert ! fpsdisplaysink video-sink=autovideosink sync=false --verbose 2>&1 | tee >/app/dlstreamer/results/gst-launch_core_$cid_count.log >(stdbuf -oL sed -n -e 's/^.*current: //p' | stdbuf -oL cut -d , -f 1 > /app/dlstreamer/results/pipeline$cid_count.log)
elif [ "$CPU_ONLY" == "1" ] 
then
	echo "Enabled CPU inference pipeline only"
	gst-launch-1.0 $INPUTSRC ! decodebin force-sw-decoders=1 ! gvadetect model-instance-id=odmodel name=detection model=$DET_MODEL model-proc=$DET_MODEL_PROC threshold=.5 device=CPU ! gvaclassify model-instance-id=clasifier labels=$RECOG_LABELS model=$RECOG_MODEL model-proc=$RECOG_MODEL_PROC device=CPU inference-region=roi-list name=classification ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/app/dlstreamer/results/r$cid_count.jsonl ! fpsdisplaysink video-sink=fakesink sync=false --verbose 2>&1 | tee >/app/dlstreamer/results/gst-launch_core_$cid_count.log >(stdbuf -oL sed -n -e 's/^.*current: //p' | stdbuf -oL cut -d , -f 1 > /app/dlstreamer/results/pipeline$cid_count.log)
else
	echo "Enabled CPU+iGPU pipeline"
	gst-launch-1.0 $INPUTSRC ! vaapidecodebin ! gvadetect model-instance-id=odmodel name=detection model=$DET_MODEL model-proc=$DET_MODEL_PROC threshold=.5 device=GPU $pre_process ! gvaclassify model-instance-id=clasifier labels=$RECOG_LABELS model=$RECOG_MODEL model-proc=$RECOG_MODEL_PROC device=CPU inference-region=roi-list name=classification ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/app/dlstreamer/results/r$cid_count.jsonl ! fpsdisplaysink video-sink=fakesink sync=false --verbose 2>&1 | tee >/app/dlstreamer/results/gst-launch_core_$cid_count.log >(stdbuf -oL sed -n -e 's/^.*current: //p' | stdbuf -oL cut -d , -f 1 > /app/dlstreamer/results/pipeline$cid_count.log)

fi