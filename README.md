# Yolov8 Efficientnet Demos
Execute a GStreamer media accelerated decode and model ensembled pipeline of Yolov8 and Efficientnet with either OpenVINO Model Server or DLStreamer for inference.

## Build Steps

1. Download the quantized yolov8 IR model

```
./download-yolov8.sh
```

2. Build GST + OVMS Docker Image

```
sudo docker build -t ovms-yolov8-efficientnet:1.0 -f Dockerfile.ovms .
```

3. Build GST + DLStreamer Yolov8 Docker Image
   
```
sudo docker build -t dls-yolov8-efficientnet:1.0 -f Dockerfile.dls-yolov8 .
```

## Run GST + OVMS E2E Pipeline Examples

**Environment variables. Note not all are shown in the below Examples for brevity**

_Used to show direct console output instead of logging to the tmp directory_<br>
DC=1 

_Video streams' location and types_<br>
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 <br>
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 <br>
INPUT_TYPE=RTSP_H264<br>
INPUT_TYPE2=RTSP_H264

_Rendering_<br>
RENDER_MODE=0 # enable rendering graphical content in a window<br>
RENDER_PORTRAIT_MODE=0 # landscape vs. portrait rendering<br>

_Pipelines_<br>
LOW_POWER=1  # GPU  pipeline<br>
CPU_ONLY=0   # CPU  pipeline<br>
LOW_POWER=0 && CPU_ONLY=0 # CPU+GPU pieline

**Yolov8 Dual Camera GPU Example**
```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 
RENDER_MODE=0
RENDER_PORTRAIT_MODE=0
LOW_POWER=1
CPU_ONLY=0
INPUT_TYPE=RTSP_H264
INPUT_TYPE2=RTSP_H264
DC=1
```

```
sudo docker run --rm --user root -it -e DC=$DC -e INPUTSRC=$INPUTSRC -e INPUTSRC2=$INPUTSRC2 -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/yolov8_ensemble/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 ovms-yolov8-efficientnet:1.0 yolov8_ensemble/yolo_efficientnet_dual.sh
```


**Yolov8 Dual Camera CPU+GPU Example**
```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 
RENDER_MODE=0
RENDER_PORTRAIT_MODE=0
LOW_POWER=0
CPU_ONLY=0
INPUT_TYPE=RTSP_H264
INPUT_TYPE2=RTSP_H264
DC=1
```

```
sudo docker run --rm --user root -it -e DC=$DC -e INPUTSRC=$INPUTSRC -e INPUTSRC2=$INPUTSRC2 -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/yolov8_ensemble/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 ovms-yolov8-efficientnet:1.0 yolov8_ensemble/yolo_efficientnet_dual.sh
```

**Yolov8 Single Camera CPU with Rendering Example**<br>
Check /tmp for log files.

```
xhost +
```

```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 
RENDER_MODE=1
RENDER_PORTRAIT_MODE=0
LOW_POWER=0
CPU_ONLY=1
INPUT_TYPE=RTSP_H264
```

```
sudo docker run --rm --user root -it -e DISPLAY=$DISPLAY -e INPUTSRC=$INPUTSRC -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/yolov8_ensemble/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 ovms-yolov8-efficientnet:1.0 yolov8_ensemble/yolo_efficientnet.sh
```

## Run GST + Dlstreamer Yolov8 E2E Pipeline Examples

**Environment variables. Note not all are shown in the below Examples for brevity**

_Used to show direct console output instead of logging to the tmp directory_<br>
DC=1 

_Video streams' location and types_<br>
INPUTSRC=rtsp://127.0.0.1:8554/camera_0 <br>
INPUTSRC2=rtsp://127.0.0.1:8554/camera_0 <br>
INPUT_TYPE=RTSP_H264<br>
INPUT_TYPE2=RTSP_H264

_Rendering_<br>
RENDER_MODE=0 # enable rendering graphical content in a window<br>

_Pipelines_<br>
LOW_POWER=1  # GPU  pipeline<br>
CPU_ONLY=0   # CPU  pipeline<br>
LOW_POWER=0 && CPU_ONLY=0 # CPU+GPU pieline<br>
MAX=1 # Stream 1 is GPU+GPU and Stream 2 is GPU+CPU

**Yolov8 Dual RTSP Camera GPU Example**
```
INPUTSRC=rtsp://127.0.0.1:8554/camera_0
INPUTSRC2=rtsp://127.0.0.1:8554/camera_1
RENDER_MODE=0
LOW_POWER=1
CPU_ONLY=0
INPUT_TYPE=RTSP_H264
INPUT_TYPE2=RTSP_H264
DC=1
```

```
sudo docker run --rm --user root -it -e DISPLAY=$DISPLAY -e DC=$DC -e INPUTSRC=$INPUTSRC -e INPUTSRC2=$INPUTSRC2 -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/dlstreamer/results -v `pwd`:/savedir --net host --ipc=host --device /dev/dri/renderD128 -e DISPLAY=$DISPLAY dls-yolov8-efficientnet:1.0 
```

```
source /home/dlstreamer/dlstreamer_gst/scripts/setup_env.sh
```

```
./yolov8_efficientnet_dual.sh
```

**Yolov8 Dual USB Camera GPU Example**
```
INPUTSRC=/dev/video0 
INPUTSRC2=/dev/video6
RENDER_MODE=0
LOW_POWER=1
CPU_ONLY=0
DC=1
```

```
sudo v4l2-ctl --list-formats-ext -d $INPUTSRC
```

```
sudo v4l2-ctl --list-formats-ext -d $INPUTSRC2
```

```
sudo docker run --rm --user root -it -e DISPLAY=$DISPLAY -e DC=$DC -e INPUTSRC=$INPUTSRC -e INPUTSRC2=$INPUTSRC2 -e RENDER_MODE=$RENDER_MODE -e LOW_POWER=$LOW_POWER -e CPU_ONLY=$CPU_ONLY -e INPUT_TYPE=$INPUT_TYPE -e INPUT_TYPE2=$INPUT_TYPE2 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/tmp:/app/dlstreamer/results -v `pwd`:/savedir --net host --ipc=host --device $INPUTSRC --device #INPUTSRC2 --device /dev/dri/renderD128 -e DISPLAY=$DISPLAY dls-yolov8-efficientnet:1.0 
```

```
source /home/dlstreamer/dlstreamer_gst/scripts/setup_env.sh
```

Single USB Camera

```
gst-launch-1.0 v4l2src device=$INPUTSRC io-mode=dmabuf ! video/x-raw,width=1280,height=720,framerate=30/1 ! vaapipostproc format=rgbx ! gvadetect model-instance-id=odmodel name=detection reshape=1 reshape-width=416 reshape-height=416 model=models/yolov8/yolov8n-int8.xml model-proc=/home/dlstreamer/dlstreamer_gst/samples/gstreamer/model_proc/public/yolo-v8.json threshold=.5 device=GPU pre-process-backend=vaapi-surface-sharing pre-process-config=VAAPI_FAST_SCALE_LOAD_FACTOR=1 ! gvaclassify model-instance-id=clasifier labels=models/efficientnet-b0/1/imagenet_2012.txt model=models/efficientnet-b0/1/FP16-INT8/efficientnet-b0.xml model-proc=models/efficientnet-b0/1/efficientnet-b0.json device=GPU inference-region=roi-list name=classification pre-process-backend=vaapi-surface-sharing pre-process-config=VAAPI_FAST_SCALE_LOAD_FACTOR=1 ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/app/dlstreamer/results/r0.jsonl ! fpsdisplaysink video-sink=fakesink sync=false --verbose
```


Dual USB Cameras
```
gst-launch-1.0 v4l2src device=$INPUTSRC io-mode=dmabuf ! video/x-raw,width=1920,height=1080,framerate=30/1 ! vaapipostproc format=rgbx ! gvadetect model-instance-id=odmodel name=detection reshape=1 reshape-width=416 reshape-height=416 model=models/yolov8/yolov8n-int8.xml model-proc=/home/dlstreamer/dlstreamer_gst/samples/gstreamer/model_proc/public/yolo-v8.json threshold=.5 device=GPU pre-process-backend=vaapi-surface-sharing pre-process-config=VAAPI_FAST_SCALE_LOAD_FACTOR=1 ! gvaclassify model-instance-id=clasifier labels=models/efficientnet-b0/1/imagenet_2012.txt model=models/efficientnet-b0/1/FP16-INT8/efficientnet-b0.xml model-proc=models/efficientnet-b0/1/efficientnet-b0.json device=GPU inference-region=roi-list name=classification pre-process-backend=vaapi-surface-sharing pre-process-config=VAAPI_FAST_SCALE_LOAD_FACTOR=1 ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/app/dlstreamer/results/r0.jsonl ! fpsdisplaysink video-sink=fakesink sync=false --verbose v4l2src device=$INPUTSRC2 io-mode=dmabuf ! video/x-raw,width=1920,height=1080,framerate=30/1 ! vaapipostproc format=rgbx ! gvadetect model-instance-id=odmodel2 name=detection2 reshape=1 reshape-width=416 reshape-height=416 model=models/yolov8/yolov8n-int8.xml model-proc=/home/dlstreamer/dlstreamer_gst/samples/gstreamer/model_proc/public/yolo-v8.json threshold=.5 device=GPU pre-process-backend=vaapi-surface-sharing pre-process-config=VAAPI_FAST_SCALE_LOAD_FACTOR=1 ! gvaclassify model-instance-id=clasifier2 labels=models/efficientnet-b0/1/imagenet_2012.txt model=models/efficientnet-b0/1/FP16-INT8/efficientnet-b0.xml model-proc=models/efficientnet-b0/1/efficientnet-b0.json device=GPU inference-region=roi-list name=classification2 pre-process-backend=vaapi-surface-sharing pre-process-config=VAAPI_FAST_SCALE_LOAD_FACTOR=1 ! gvametaconvert name=metaconvert2 add-empty-results=true ! gvametapublish name=destination2 file-format=2 file-path=/app/dlstreamer/results/r.jsonl ! fpsdisplaysink video-sink=fakesink sync=false --verbose
```
